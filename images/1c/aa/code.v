module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b00000000;  
        end else if (enable) begin  
            data_out <= {data_out[6:0], 1'b0}; // Shift right with zero fill  
        end  
    end  
endmodule