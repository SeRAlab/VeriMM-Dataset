module shift_register (  
    input clk,  
    input reset,  
    input load,  
    input dir,  // 0 for left shift, 1 for right shift  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 2'b00;  
        end else if (load) begin  
            data_out <= data_in;  
        end else if (dir == 0) begin  
            data_out <= {data_out[0], 1'b0}; // Shift left  
        end else begin  
            data_out <= {1'b0, data_out[1]}; // Shift right  
        end  
    end  
endmodule