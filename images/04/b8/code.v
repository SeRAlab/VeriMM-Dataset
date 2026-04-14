module PIPO_Shift_Register(  
    input wire clk,  
    input wire load,  
    input wire shift,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] register;  

    always @(posedge clk) begin  
        if (load) begin  
            register <= data_in;  
        end else if (shift) begin  
            data_out <= register;  
            register <= {1'b0, register[7:1]};  
        end  
    end  
endmodule