module top_module(
    input clk,
    input reset,
    input [8:0] rom_addr,
    input [25:0] rom_q,
    output reg [5:0] ram_a_addr,
    output reg [5:0] ram_b_addr,
    output reg ram_b_w,
    output reg [10:0] pe,
    output reg done
);// Internal registers
    reg [5:0] dest;
    reg [1:0] op;
    reg [5:0] times;
    reg [5:0] src1;
    reg [5:0] src2;
    reg [10:0] result;

    always @ (posedge clk) begin
        if (reset) begin
            // Reset all registers
            dest <= 0;
            op <= 0;
            times <= 0;
            src1 <= 0;
            src2 <= 0;
            result <= 0;
            ram_a_addr <= 0;
            ram_b_addr <= 0;
            ram_b_w <= 0;
            pe <= 0;
            done <= 0;
        end else begin
            // Read instruction from rom_q
            {dest, src1, op, times, src2} <= rom_q;

            // Set RAM addresses
            ram_a_addr <= src1;
            ram_b_addr <= src2;

            // Perform operation
            case(op)
                2'b00: begin // ADD
                    result <= src1 + src2;
                end
                2'b01: begin // SUB
                    result <= src1 - src2;
                end
                2'b10: begin // CUBIC
                    result <= src1 * src1 * src1 * times;
                end
                2'b11: begin // MULT
                    result <= src1 * src2;
                end
                default: begin
                    result <= 0;
                end
            endcase

            // Write result to RAM B
            ram_b_w <= 1;
            pe <= result;
            done <= 1;
        end
    end
endmodule