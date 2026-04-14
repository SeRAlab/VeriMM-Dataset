module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] in,
    output [3:0] out,
    output ser_out
);reg [3:0] shift_reg;
    reg [3:0] twos_comp;
    wire [3:0] and_out;
    reg ser_out_reg;

    // Shift Register
    always @(posedge clk, negedge reset) begin
        if (reset == 0) begin
            shift_reg <= 4'b0000;
        end else if (load == 1) begin
            shift_reg <= in;
        end else begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

    // 2's Complement
    always @(*) begin
        if (shift_reg[3] == 1) begin
            twos_comp = ~(shift_reg) + 1;
        end else begin
            twos_comp = shift_reg;
        end
    end

    // AND Gate
    assign and_out = twos_comp & shift_reg;

    // Serial Output
    always @(posedge clk, negedge reset) begin
        if (reset == 0) begin
            ser_out_reg <= 1'b0;
        end else begin
            ser_out_reg <= shift_reg[0];
        end
    end

    // Output
    assign out = and_out;
    assign ser_out = ser_out_reg;

endmodule