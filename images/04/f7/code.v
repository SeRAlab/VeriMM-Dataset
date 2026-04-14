module convolutional_encoder (  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg [1:0] data_out  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  
    wire feedback1, feedback2;  
  
    // Feedback connections based on generator polynomials  
    assign feedback1 = data_in ^ state[1] ^ state[2]; // G1 = 101  
    assign feedback2 = data_in ^ state[0] ^ state[2]; // G2 = 111  
  
    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= 3'b000;  
        else  
            state <= next_state;  
    end  
  
    // Output generation  
    always @(*) begin  
        data_out = {feedback2, feedback1};  
        next_state = {data_in, state[2:1]};  
    end  
endmodule