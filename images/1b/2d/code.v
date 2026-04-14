module PIPO_Shift_Register (  
    input wire clk,  
    input wire load,  
    input wire [7:0] parallel_in,  
    output reg [7:0] parallel_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            parallel_out <= parallel_in;  
        end else begin  
            parallel_out <= {parallel_out[6:0], 1'b0}; // Shift left and add 0 at LSB  
        end  
    end  
endmodule