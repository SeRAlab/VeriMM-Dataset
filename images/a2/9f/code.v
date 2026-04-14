module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] result
);reg [4:0] multiplier;
reg [5:0] product;
reg [2:0] state;

always @(*) begin
    case (state)
        0: begin
            multiplier <= {1'b0, A};
            product <= {4'b0, B};
            state <= 1;
        end
        1: begin
            if (product[0] == 1) begin
                product <= product - multiplier;
                result <= result + multiplier;
            end
            multiplier <= {multiplier[3:1], multiplier[0]};
            product <= {product[4:1], product[0]};
            state <= (multiplier == 5'b00000) ? 2 : 1;
        end
        2: begin
            state <= 2;
        end
    endcase
end

endmodule