module top_module(
    output reg [7:0] w_bus_high_reg,
    output reg [7:0] w_bus_low_reg,
    input [7:0] w_bus_instr_word,
    input [7:0] w_bus_write_back_value,
    input [3:0] w_bus_write_back_reg,
    input w_write_back,
    input w_clock,
    input w_reset
);reg [7:0] r_registers[0:15];
    wire [7:0] a0, a1, a2, a3, r2, r3, r4, r5, r6, r7, r8, r10, r13, r14, r15;
    integer i;

    assign a0 = r_registers[1];
    assign a1 = r_registers[9];
    assign a2 = r_registers[11];
    assign a3 = r_registers[12];
    assign r2 = r_registers[2];
    assign r3 = r_registers[3];
    assign r4 = r_registers[4];
    assign r5 = r_registers[5];
    assign r6 = r_registers[6];
    assign r7 = r_registers[7];
    assign r8 = r_registers[8];
    assign r10 = r_registers[10];
    assign r13 = r_registers[13];
    assign r14 = r_registers[14];
    assign r15 = r_registers[15];

    initial begin
        for (i = 0; i < 16; i = i + 1) r_registers[i] = 8'b00000000;
        $monitor("$arg0:%x, $arg1:%x, $arg2:%x, $arg3:%x, $and:%x, $or:%x, $add:%x, $rlf:%x, $rrt:%x, $sle:%x, $sge:%x, $jal:%x, $lw:%x, $sw:%x, $mov:%x", a0, a1, a2, a3, r2, r3, r4, r5, r6, r7, r8, r10, r13, r14, r15);
    end

    always @(posedge w_clock) begin
        if (w_write_back && w_bus_write_back_reg != 4'b0000) begin
            r_registers[w_bus_write_back_reg] <= w_bus_write_back_value;
        end
        if (w_reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                r_registers[i] = 8'b00000000;
            end
        end
    end

    assign w_bus_high_reg = r_registers[w_bus_instr_word[7:4]];
    assign w_bus_low_reg = r_registers[w_bus_instr_word[3:0]];
endmodule