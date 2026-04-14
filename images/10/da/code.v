module shift_register_16bit(  
    input wire clk,  
    input wire load,  
    input wire shift_dir,  // 0 for left shift, 1 for right shift  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end else begin  
            if (shift_dir) begin  
                data_out <= {1'b0, data_out[15:1]}; // Right shift  
            end else begin  
                data_out <= {data_out[14:0], 1'b0}; // Left shift  
            end  
        end  
    end  
endmodule