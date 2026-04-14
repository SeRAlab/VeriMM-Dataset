module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    output [7:0] q    // 8-bit output from the functional module
);reg [7:0] reg_q;    // 8-bit register output
    reg [7:0] shift_q;  // 8-bit shift register output
    reg [7:0] sum_q;    // 8-bit sum output
    
    // T flip-flops for the register
    reg t1, t2, t3, t4, t5, t6, t7, t8;
    
    // Combinational logic for the shift register
    wire [7:0] shift_d = {shift_q[6:0], reg_q[0]}; // Shift in data on positive edge
    wire [7:0] shift_qn = {shift_q[7], shift_q[7:1]}; // Shift out data on negative edge
    
    // Register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            t1 <= 1'b0;
            t2 <= 1'b0;
            t3 <= 1'b1;
            t4 <= 1'b1;
            t5 <= 1'b0;
            t6 <= 1'b1;
            t7 <= 1'b0;
            t8 <= 1'b0;
            reg_q <= 8'h34; // Reset to 0x34
        end else begin
            t1 <= d[0] ^ t2;
            t2 <= t1 ^ t3;
            t3 <= t2 ^ t4;
            t4 <= t3 ^ t5;
            t5 <= t4 ^ t6;
            t6 <= t5 ^ t7;
            t7 <= t6 ^ t8;
            t8 <= t7 ^ d[7];
            reg_q <= {t8, t7, t6, t5, t4, t3, t2, t1};
        end
    end
    
    // Shift register
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            shift_q <= 8'h00;
        end else begin
            shift_q <= shift_qn;
        end
    end
    
    // Functional module that outputs the sum of the register and shift register
    always @(*) begin
        sum_q = reg_q + shift_q;
    end
    
    assign q = sum_q; // Output the sum
    
endmodule