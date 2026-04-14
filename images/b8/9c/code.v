module top_module(
    input clk,
    input reset,
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] in_reg;
reg [7:0] in_reg_prev;
reg [2:0] pos_reg;

// Binary edge detector module
reg [2:0] edge_pos;
reg [2:0] edge_pos_reg;
reg [7:0] edge_count;

always @(posedge clk) begin
    if (reset) begin
        in_reg <= 0;
        in_reg_prev <= 0;
        pos_reg <= 0;
        edge_pos_reg <= 0;
        edge_count <= 0;
    end else begin
        in_reg <= in;
        in_reg_prev <= in_reg;
        pos_reg <= pos;
        edge_pos_reg <= edge_pos;
        edge_count <= (in_reg != in_reg_prev) ? 1 : edge_count + 1;
        if (edge_count == 1) begin
            edge_pos <= 0;
            if (in_reg[7]) edge_pos <= 7;
            if (in_reg[6]) edge_pos <= 6;
            if (in_reg[5]) edge_pos <= 5;
            if (in_reg[4]) edge_pos <= 4;
            if (in_reg[3]) edge_pos <= 3;
            if (in_reg[2]) edge_pos <= 2;
            if (in_reg[1]) edge_pos <= 1;
            if (in_reg[0]) edge_pos <= 0;
        end
    end
end

// Priority encoder module
always @* begin
    case (edge_pos_reg)
        3'b000: pos_reg <= 3'b000;
        3'b001: pos_reg <= 3'b001;
        3'b010: pos_reg <= 3'b010;
        3'b011: pos_reg <= 3'b011;
        3'b100: pos_reg <= 3'b100;
        3'b101: pos_reg <= 3'b101;
        3'b110: pos_reg <= 3'b110;
        3'b111: pos_reg <= 3'b111;
        default: pos_reg <= pos_reg;
    endcase
end

// Final output module
always @(posedge clk) begin
    if (reset) begin
        pos <= 0;
    end else begin
        pos <= pos_reg;
    end
end

endmodule