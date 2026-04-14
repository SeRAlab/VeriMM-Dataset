module PIPO_Shift_Register(  
    input clk,  
    input load_en,  
    input shift_en,  
    input [4:0] data_in,  
    output reg [4:0] data_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk) begin  
        if (load_en) begin  
            shift_reg <= data_in;  
        end else if (shift_en) begin  
            data_out <= shift_reg;  
            shift_reg <= {1'b0, shift_reg[4:1]}; // Shift left, inserting 0  
        end  
    end  
endmodule