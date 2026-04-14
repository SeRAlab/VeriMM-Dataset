module top_module(
   inputState, inputSelect, out, configInvalid
);parameter NUM_INPUTS = 17;
   parameter NUM_INPUTS_LOG_2 = 5;  
   parameter INPUT_WIDTH = 32;
   
   
   input  [(NUM_INPUTS*INPUT_WIDTH)-1:0] inputState;   
                                                
                                                
   input [NUM_INPUTS_LOG_2-1:0]          inputSelect;  
   output [INPUT_WIDTH-1:0]              out;
   output                                configInvalid;

   reg [INPUT_WIDTH-1:0]                 out;

   
   assign configInvalid = inputSelect >= NUM_INPUTS; 

   
   always @(inputSelect or inputState)begin
      case(inputSelect)
        0: out = inputState[INPUT_WIDTH*1-1:INPUT_WIDTH*0];
        1: out = inputState[INPUT_WIDTH*2-1:INPUT_WIDTH*1];
        2: out = inputState[INPUT_WIDTH*3-1:INPUT_WIDTH*2];
        3: out = inputState[INPUT_WIDTH*4-1:INPUT_WIDTH*3];
        4: out = inputState[INPUT_WIDTH*5-1:INPUT_WIDTH*4];
        5: out = inputState[INPUT_WIDTH*6-1:INPUT_WIDTH*5];
        6: out = inputState[INPUT_WIDTH*7-1:INPUT_WIDTH*6];
        7: out = inputState[INPUT_WIDTH*8-1:INPUT_WIDTH*7];
        8: out = inputState[INPUT_WIDTH*9-1:INPUT_WIDTH*8];
        9: out = inputState[INPUT_WIDTH*10-1:INPUT_WIDTH*9];
        10: out = inputState[INPUT_WIDTH*11-1:INPUT_WIDTH*10];
        11: out = inputState[INPUT_WIDTH*12-1:INPUT_WIDTH*11];
        12: out = inputState[INPUT_WIDTH*13-1:INPUT_WIDTH*12];
        13: out = inputState[INPUT_WIDTH*14-1:INPUT_WIDTH*13];
        14: out = inputState[INPUT_WIDTH*15-1:INPUT_WIDTH*14];
        15: out = inputState[INPUT_WIDTH*16-1:INPUT_WIDTH*15];
        16: out = inputState[INPUT_WIDTH*17-1:INPUT_WIDTH*16];
	default : out = 0;
      endcase
   end
endmodule