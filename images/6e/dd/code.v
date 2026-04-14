module top_module(
    input start,
    input clk,
    input [2:0] multiplier,
    input [2:0] multiplicand,
    output reg [5:0] p,
    output reg done
);reg [2:0] m;
    reg [2:0] mc;
    reg [2:0] p_reg;
    reg [1:0] count;
    
    always @(posedge clk) begin
        if (start == 1) begin
            m <= multiplier;
            mc <= multiplicand;
            count <= 0;
            p_reg <= 0;
            p <= 0;
            done <= 0;
        end
        else if (count < 3) begin
            p_reg <= {p_reg[4:0], m[0] & mc[count]};
            count <= count + 1;
        end
        else begin
            p <= {p_reg[4:0], m[1] & mc[0]};
            done <= 1;
        end
    end
    
endmodule