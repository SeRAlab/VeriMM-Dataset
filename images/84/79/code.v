module top_module(
    input CLK,
    input RESET,
    output reg [3:0] OUT
);reg [3:0] OUT_reg;
reg direction;

always @(posedge CLK) begin
    if (RESET) begin
        OUT_reg <= 4'b0000;
        direction <= 1'b0;
    end else begin
        if (OUT_reg[2] == 1'b1) begin
            direction <= ~direction;
        end
        if (direction == 1'b0) begin
            OUT_reg <= {OUT_reg[2:0], OUT_reg[3]}; // Shift left
        end else begin
            OUT_reg <= {OUT_reg[0], OUT_reg[3:1]}; // Shift right (corrected part select order)
        end
    end
end

assign OUT = OUT_reg;

endmodule