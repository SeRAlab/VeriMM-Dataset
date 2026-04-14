module top_module(
    input mode,
    input [2:0] GColor,
    input VColor,
    output reg VGA_R,
    output reg VGA_G,
    output reg VGA_B
    );always @ * begin  
        if(mode == 0) begin  
            VGA_R <= VColor;
            VGA_G <= VColor;
            VGA_B <= VColor;
        end else begin  
            VGA_R <= GColor[2];
            VGA_G <= GColor[1];
            VGA_B <= GColor[0];
        end
    end

endmodule