module top_module(
    input [7:0] I,
    input EN,
    output reg [2:0] Y
);reg [7:0] I_reg;
reg [2:0] Y_reg;

always @(posedge EN) begin
    I_reg <= I;
    Y_reg <= {3'b0};
end

always @(posedge EN) begin
    if (I_reg[7]) Y_reg <= 3'b000;
    else if (I_reg[6]) Y_reg <= 3'b001;
    else if (I_reg[5]) Y_reg <= 3'b010;
    else if (I_reg[4]) Y_reg <= 3'b011;
    else if (I_reg[3]) Y_reg <= 3'b100;
    else if (I_reg[2]) Y_reg <= 3'b101;
    else if (I_reg[1]) Y_reg <= 3'b110;
    else if (I_reg[0]) Y_reg <= 3'b111;
end

always @(posedge EN) begin
    if (I_reg[7]) Y_reg[1] <= 1'b1;
    else if (I_reg[6]) Y_reg[1] <= 1'b1;
    else if (I_reg[5]) Y_reg[1] <= 1'b1;
    else if (I_reg[4]) Y_reg[1] <= 1'b1;
    else if (I_reg[3]) Y_reg[1] <= 1'b1;
    else if (I_reg[2]) Y_reg[1] <= 1'b1;
    else if (I_reg[1]) Y_reg[1] <= 1'b1;
    else if (I_reg[0]) Y_reg[1] <= 1'b1;
end

always @(posedge EN) begin
    if (I_reg[7] || I_reg[6] || I_reg[5] || I_reg[4] || I_reg[3] || I_reg[2] || I_reg[1] || I_reg[0]) Y_reg[2] <= 1'b0;
    else Y_reg[2] <= 1'b1;
end

assign Y = Y_reg;

endmodule