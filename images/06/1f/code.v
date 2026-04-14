module shift_register(  
    input clk,  
    input dir,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk) begin  
        if (dir) begin  // 1 for left shift  
            data_out <= {data_out[2:0], data_in[0]};  
        end else begin  // 0 for right shift  
            data_out <= {data_in[3], data_out[3:1]};  
        end  
    end  
endmodule