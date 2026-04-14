module shift_register (  
    input clk,  
    input [15:0] data_in,  
    input shift_dir,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (shift_dir) begin  
            data_out <= {data_out[14:0], 1'b0}; // Right shift  
        end else begin  
            data_out <= {1'b0, data_out[15:1]}; // Left shift  
        end  
    end  
endmodule