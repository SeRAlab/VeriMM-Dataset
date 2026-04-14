module ShiftRegister(  
    input clk,  
    input load_enable,  
    input shift_enable,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (load_enable) begin  
            data_out <= data_in;  
        end else if (shift_enable) begin  
            data_out <= {data_out[14:0], 1'b0};  
        end  
    end  
endmodule