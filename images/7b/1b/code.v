module top_module(
    input [31:0] val_i,
    output reg [31:0] val_o,
    input [2:0] funct3
);always @*
    begin
        if(funct3 == 0) 
            val_o = { {24{val_i[7]}}, val_i[7:0] };
        else if(funct3 == 1) 
            val_o = { {16{val_i[15]}}, val_i[15:0] };
        else if(funct3 == 2) 
            val_o = val_i;
        else if(funct3 == 4) 
            val_o = { {24{1'b0}}, val_i[7:0] };
        else if(funct3 == 5) 
            val_o = { {16{1'b0}}, val_i[15:0] };
    end



endmodule