module top_module(
    se_i,
    shamt_i,
    data1_i,
    data2_i,
    leftright_i,
    data_o
    );input [32-1:0] se_i;
input [5-1:0] shamt_i;
input [32-1:0] data1_i;
input [32-1:0] data2_i;
input [3-1:0] leftright_i;
output [32-1:0] data_o;

reg     [32-1:0] data_o;

always@(*)begin
    
    case(leftright_i)
        
        
        3'b010: data_o <= se_i << 2;

        
        
        3'b011: data_o <= se_i << 16;
        
        
        
        3'b000: data_o <= $signed(data2_i) >>> shamt_i;

        
        
        3'b001: data_o <= $signed(data2_i) >>> data1_i;

        
        
        3'b100: data_o <= $signed(data2_i) <<< shamt_i;
        
    endcase
end

endmodule