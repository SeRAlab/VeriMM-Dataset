module top_module(
    input clk,
    input rst_n,
    input [7:0] input1,
    input [7:0] input2,
    input [7:0] input3,
    input [7:0] input4,
    input sel_b1,
    input sel_b2,
    output [15:0] Johnson_out,
    output reg [15:0] mux_out
);reg [7:0] johnson_reg;
reg [15:0] johnson_ram [0:7];
reg [2:0] johnson_ptr;

always @(posedge clk) begin
    if (!rst_n) begin
        johnson_reg <= 8'h01;
        johnson_ptr <= 3'b000;
        johnson_ram[0] <= 16'h0001;
        johnson_ram[1] <= 16'h0002;
        johnson_ram[2] <= 16'h0004;
        johnson_ram[3] <= 16'h0008;
        johnson_ram[4] <= 16'h0010;
        johnson_ram[5] <= 16'h0020;
        johnson_ram[6] <= 16'h0040;
        johnson_ram[7] <= 16'h0080;
    end else begin
        if (clk) begin
            if (johnson_ptr == 3'b000) begin
                johnson_reg <= johnson_reg << 1;
                johnson_reg[0] <= ~johnson_reg[7];
            end
            johnson_ptr <= johnson_ptr + 1;
            if (johnson_ptr == 3'b100) begin
                johnson_ptr <= 3'b000;
            end
        end
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        mux_out <= 16'h0000;
    end else begin
        if (clk) begin
            case ({sel_b1, sel_b2})
                2'b00: mux_out <= input1;
                2'b01: mux_out <= input2;
                2'b10: mux_out <= input3;
                2'b11: mux_out <= input4;
            endcase
        end
    end
end

assign Johnson_out = johnson_ram[johnson_reg];

endmodule