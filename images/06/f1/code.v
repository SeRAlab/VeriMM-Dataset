module PIPO_Shift_Register (  
    input wire [4:0] data_in,  
    input wire load,  
    input wire clk,  
    output reg [4:0] data_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end  
    end  
endmodule