// Copyright 2020 Mobvoi Inc. All Rights Reserved.
// Author: binbinzhang@mobvoi.com (Binbin Zhang)
//         di.wu@mobvoi.com (Di Wu)
//         lizexuan@huya.com (Zexuan Li)
//         sxc19@mails.tsinghua.edu.cn (Xingchen Song)
//         hamddct@gmail.com (Mddct)

#ifndef DECODER_OPENVINO_ASR_MODEL_H_
#define DECODER_OPENVINO_ASR_MODEL_H_

#include <memory>
#include <string>
#include <vector>

#include "openvino/openvino.hpp"

#include "decoder/asr_model.h"
#include "utils/utils.h"
#include "utils/log.h"

namespace wenet {

class OVAsrModel : public AsrModel {
 public:
  // Note: Do not call the InitEngineThreads function more than once.
  void InitEngineThreads(int num_threads = 1);

 public:
  OVAsrModel()=default;
  ~OVAsrModel();
  OVAsrModel(const OVAsrModel& other);
  void Read(const std::string& model_dir);
  void Reset() override;
  void AttentionRescoring(const std::vector<std::vector<int>>& hyps,
                          float reverse_weight,
                          std::vector<float>* rescoring_score) override;
  std::shared_ptr<AsrModel> Copy() const override;

 protected:
  void ForwardEncoderFunc(const std::vector<std::vector<float>>& chunk_feats,
                          std::vector<std::vector<float>>* ctc_prob) override;

  float ComputeAttentionScore(const float* prob, const std::vector<int>& hyp,
                              int eos, int decode_out_len);

 private:
  int encoder_output_size_ = 0;
  int num_blocks_ = 0;
  int cnn_module_kernel_ = 0;
  int head_ = 0;

  static std::shared_ptr<ov::Core> core_;
  // sessions
  // NOTE(Mddct): The Env holds the logging state used by all other objects.
  //  One Env must be created before using any other Onnxruntime functionality.

  std::shared_ptr<ov::CompiledModel> encoder_compile_model_;
  std::shared_ptr<ov::CompiledModel> ctc_compile_model_;
  std::shared_ptr<ov::CompiledModel> rescore_compile_model_;

  std::shared_ptr<ov::InferRequest> encoder_infer_;
  std::shared_ptr<ov::InferRequest> ctc_infer_;
  std::shared_ptr<ov::InferRequest> rescore_infer_;

  std::vector<std::string> encoder_input_names_;
  // caches
  ov::Tensor att_cache_ov_;
  ov::Tensor cnn_cache_ov_;
  std::vector<ov::Tensor> encoder_outs_;
  
  //  our data "alive" during the lifetime of decoder.
  std::vector<float> att_cache_;
  std::vector<float> cnn_cache_;
};

}  // namespace wenet

#endif  // DECODER_OPENVINO_ASR_MODEL_H_
