module siso_shift_register #(parameter WIDTH = 5) (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [WIDTH-1:0] serial_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            serial_out <= 0;  
        end else begin  
            serial_out <= {serial_out[WIDTH-2:0], serial_in};  
        end  
    end  
endmodule