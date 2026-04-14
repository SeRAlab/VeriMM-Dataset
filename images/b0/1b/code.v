module top_module(
    input [7:0] I,
    input clk, // Added clock input
    output reg EN,
    output reg V,
    output reg [2:0] Q
);reg [7:0] I_reg;
reg [7:0] I_next;
reg [2:0] Q_reg;
reg [2:0] Q_next;
reg [2:0] Q_next_next;
reg [2:0] Q_next_next_next;

always @(posedge clk) begin
    I_reg <= I;
end

always @(posedge clk) begin
    I_next <= I_reg;
end

always @(posedge clk) begin
    Q_reg <= Q_next_next;
end

always @(posedge clk) begin
    Q_next <= Q_reg;
end

always @(posedge clk) begin
    Q_next_next <= Q_next_next_next;
end

always @(posedge clk) begin
    if (I_next[7] == 1) begin
        Q_next_next_next <= 3'b111; // Fixed to use 3'b for 3-bit value
    end else if (I_next[6] == 1) begin
        Q_next_next_next <= 3'b110;
    end else if (I_next[5] == 1) begin
        Q_next_next_next <= 3'b101;
    end else if (I_next[4] == 1) begin
        Q_next_next_next <= 3'b100;
    end else if (I_next[3] == 1) begin
        Q_next_next_next <= 3'b011;
    end else if (I_next[2] == 1) begin
        Q_next_next_next <= 3'b010;
    end else if (I_next[1] == 1) begin
        Q_next_next_next <= 3'b001;
    end else if (I_next[0] == 1) begin
        Q_next_next_next <= 3'b000;
    end else begin
        Q_next_next_next <= Q_next;
    end
end

always @(posedge clk) begin
    if (I_next != 8'b00000000) begin
        EN <= 1;
    end else begin
        EN <= 0;
    end
end

always @(posedge clk) begin
    if (I_next != 8'b00000000 && V == 0) begin
        V <= 1;
    end else if (I_next != 8'b00000000 && V == 1) begin
        V <= 0;
    end
end

assign Q = Q_reg;

endmodule