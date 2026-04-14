module shift_register (  
    input clk,  
    input reset,  
    input mode,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 16'd0;  
        end else if (mode) begin  
            data_out <= {1'b0, data_out[15:1]}; // Right shift  
        end else begin  
            data_out <= {data_out[14:0], 1'b0}; // Left shift  
        end  
    end  
endmodule