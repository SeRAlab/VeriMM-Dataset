module PISO (  
    input [4:0] data,  
    input load,  
    input clk,  
    input rst,  
    output reg serial_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 5'b00000;  
            serial_out <= 0;  
        end else if (load) begin  
            shift_reg <= data;  
        end else begin  
            serial_out <= shift_reg[0];  
            shift_reg <= {1'b0, shift_reg[4:1]};  
        end  
    end  
endmodule