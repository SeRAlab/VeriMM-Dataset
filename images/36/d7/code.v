module turbo_encoder (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [7:0] encoded_out  
);  
    wire [3:0] encoded_0, encoded_1;  

    // Simple convolutional encoder logic (Rate 1/2 for example purposes)  
    assign encoded_0 = {data_in[3], data_in[2], data_in[3] ^ data_in[2], data_in[1]};  
    assign encoded_1 = {data_in[0], data_in[3] ^ data_in[1], data_in[2] ^ data_in[1], data_in[0] ^ data_in[2]};  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            encoded_out <= 8'b0;  
        else  
            encoded_out <= {encoded_0, encoded_1};  
    end  
endmodule