module shift_register(  
    input clk,  
    input reset,  
    input load,  
    input shift_dir, // 1 for left shift, 0 for right shift  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 16'b0;  
        end else if (load) begin  
            data_out <= data_in;  
        end else if (shift_dir) begin  
            data_out <= {data_out[14:0], 1'b0}; // Left shift  
        end else begin  
            data_out <= {1'b0, data_out[15:1]}; // Right shift  
        end  
    end  
endmodule