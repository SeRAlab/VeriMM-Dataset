module shift_register(  
    input wire clk,  
    input wire [1:0] data_in,  
    input wire shift_dir,  // 0 for left, 1 for right  
    output reg [1:0] data_out  
);  
    always @(posedge clk) begin  
        if (shift_dir == 0) begin  
            data_out <= {data_in[0], data_out[1]}; // Shift left  
        end else begin  
            data_out <= {data_out[0], data_in[1]}; // Shift right  
        end  
    end  
endmodule