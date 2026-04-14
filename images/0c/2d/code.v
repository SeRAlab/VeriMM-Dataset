module turbo_encoder (  
    input clk,  
    input rst,  
    input data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 2'b00;  
        end else begin  
            // Simple convolutional encoding logic  
            data_out[0] <= data_in; // Original data  
            data_out[1] <= data_in ^ (data_out[0]); // Parity bit  
        end  
    end  
endmodule