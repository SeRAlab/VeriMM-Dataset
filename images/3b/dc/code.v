module shift_register (  
    input clk,  
    input enable,  
    input serial_in,  
    output reg [3:0] shift_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            shift_out <= {shift_out[2:0], serial_in};  
        end  
    end  
endmodule