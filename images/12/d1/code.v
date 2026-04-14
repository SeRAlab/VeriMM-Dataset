module sipo_shift_register #(parameter WIDTH = 8) (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [WIDTH-1:0] parallel_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            parallel_out <= 0;  
        end else begin  
            parallel_out <= {parallel_out[WIDTH-2:0], serial_in};  
        end  
    end  
endmodule