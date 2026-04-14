module turbo_encoder (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] data_in,  
    output reg [3:0] encoded_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            encoded_out <= 4'b0000;  
        end else begin  
            encoded_out[3:2] <= {data_in[1], data_in[0]};  
            encoded_out[1:0] <= {data_in[0] ^ data_in[1], data_in[0]};  
        end  
    end  
endmodule