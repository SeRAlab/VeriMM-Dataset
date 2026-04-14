module top_module(
    input clk,
    input rst_n,
    output reg [63:0] johnson_out,
    input t_d,
    output reg t_out,
    output reg [63:0] final_out
);reg [5:0] johnson_reg; // 6-bit shift register for Johnson counter
reg [1:0] mux_sel;     // 2-bit select signal for multiplexer
wire [63:0] and_out;   // Bitwise AND output of Johnson and T flip-flop

// Johnson counter
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        johnson_reg <= 6'b000001;
    end else begin
        johnson_reg <= {johnson_reg[4:0], johnson_reg[5]};
    end
end

// Multiplexer to select the output of the Johnson counter
always @* begin
    case (johnson_reg)
        6'b000001: mux_sel = 2'b00;
        6'b000010: mux_sel = 2'b01;
        6'b000100: mux_sel = 2'b10;
        6'b001000: mux_sel = 2'b11;
        6'b010000: mux_sel = 2'b10;
        6'b100000: mux_sel = 2'b01;
        default: mux_sel = 2'b00;
    endcase
end

// T flip-flop
always @* begin
    if (t_d) begin
        t_out = ~t_out;
    end
end

// Functional module to generate the final output
assign and_out = johnson_out & t_out;
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        final_out <= 64'b0;
    end else begin
        final_out <= and_out;
    end
end

// Output assignment
always @* begin
    case (mux_sel)
        2'b00: johnson_out = 64'b0000000000000000000000000000000000000000000000000000000000000001;
        2'b01: johnson_out = 64'b0000000000000000000000000000000000000000000000000000000000000010;
        2'b10: johnson_out = 64'b0000000000000000000000000000000000000000000000000000000000000100;
        2'b11: johnson_out = 64'b0000000000000000000000000000000000000000000000000000000000001000;
        default: johnson_out = 64'b0;
    endcase
end

endmodule