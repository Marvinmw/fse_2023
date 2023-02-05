# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
import torch
import torch.nn as nn
import torch
    
    
class BertModel(nn.Module):   
    '''
    https://github.com/microsoft/CodeXGLUE/tree/b3048e0c1a66f437f315526313e2804871520d23/Code-Code/Defect-detection/code
    '''
    def __init__(self, encoder,config,tokenizer,args):
        super(BertModel, self).__init__()
        self.encoder = encoder
        self.config=config
        self.tokenizer=tokenizer
        self.args=args
    
        
    def forward(self, input_ids=None,labels=None): 
        outputs=self.encoder(input_ids,attention_mask=input_ids.ne(1))[0]
        logits=outputs
        prob=torch.sigmoid(logits)
        if labels is not None:
            labels=labels.float()
            loss=torch.log(prob[:,0]+1e-10)*labels+torch.log((1-prob)[:,0]+1e-10)*(1-labels)
            loss=-loss.mean()
            return loss,prob
        else:
            return prob
      

class CodeT5Model(nn.Module):
    '''
    https://github.com/salesforce/CodeT5/blob/main/models.py
    CodeT5 code
    '''
    def __init__(self, encoder, config, tokenizer, args):
        super(CodeT5Model, self).__init__()
        self.encoder = encoder
        self.config = config
        self.tokenizer = tokenizer
        self.classifier = nn.Linear(config.hidden_size, 1)
        self.args = args

    

    def forward(self, source_ids=None, labels=None):
        #source_ids = source_ids.view(-1, self.args.max_source_length)
        outputs=self.encoder(source_ids,attention_mask=source_ids.ne(1))[0][:,0,:]
        # if self.args.model_type == 'codet5':
        #vec = self.get_t5_vec(source_ids)
        # elif self.args.model_type == 'bart':
        #     vec = self.get_bart_vec(source_ids)
        # elif self.args.model_type == 'roberta':
        #     vec = self.get_roberta_vec(source_ids)

        logits = self.classifier(outputs)
        prob=torch.sigmoid(logits)
        if labels is not None:
            labels=labels.float()
            loss=torch.log(prob[:,0]+1e-10)*labels+torch.log((1-prob)[:,0]+1e-10)*(1-labels)
            loss=-loss.mean()
            return loss,prob
        else:
            return prob

 
