module SIPO_Shift_Register (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [4:0] parallel_out,  
    output reg valid  
);  
    reg [3:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 5'b0;  
            bit_count <= 4'b0;  
            valid <= 1'b0;  
        end else if (bit_count < 4'd5) begin  
            parallel_out <= {parallel_out[3:0], serial_in};  
            bit_count <= bit_count + 1;  
        end else begin  
            valid <= 1'b1;  
        end  
    end  
endmodule