`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    reg [1:0] s;
    wire [7:0] p1;
    wire [7:0] p2;
    wire [7:0] p3;
    wire [7:0] p4;
    wire [7:0] p5;
    wire [7:0] p6;
    wire [7:0] q1;
    wire [7:0] q2;
    wire [7:0] q3;
    wire [7:0] q4;
    wire [7:0] q5;
    wire [7:0] q6;
    wire [7:0] r1;
    wire [7:0] r2;
    wire [7:0] w1;
    wire [7:0] w2;
    wire [7:0] w3;
    wire [7:0] w4;
    wire [7:0] w5;
    wire [7:0] w6;
    wire [7:0] x1;
    wire [7:0] x2;
    wire [7:0] x3;
    wire [7:0] x4;
    wire [7:0] x5;
    wire [7:0] x6;
    wire [7:0] y1;
    wire [7:0] y2;
    wire [7:0] y3;
    wire [7:0] y4;
    wire [7:0] y5;
    wire [7:0] y6;
    wire [7:0] z1;
    wire [7:0] z2;
    wire [7:0] z3;
    wire [7:0] z4;
    wire [7:0] z5;
    wire [7:0] z6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .s(s),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .q1(q1),
        .q2(q2),
        .q3(q3),
        .q4(q4),
        .q5(q5),
        .q6(q6),
        .r1(r1),
        .r2(r2),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .w5(w5),
        .w6(w6),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .y5(y5),
        .y6(y6),
        .z1(z1),
        .z2(z2),
        .z3(z3),
        .z4(z4),
        .z5(z5),
        .z6(z6)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            a = 8'h00;
            b = 8'h00;
            s = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Zero Inputs", test_num);
            reset_dut();

            a = 8'h00;
            b = 8'h00;
            s = 2'b00;


            @(posedge clk);
            #2;




            #1;





            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();

            a = 8'hAA;
            b = 8'h55;
            s = 2'b01;

            @(posedge clk);
            #2;




            #1;





            check_outputs(
                8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55,
                8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA,
                8'hAA, 8'h55,
                8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55,
                8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55,
                8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55,
                8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High/Low Nibbles and S=11", test_num);
            reset_dut();

            a = 8'hF0;
            b = 8'h0F;
            s = 2'b11;

            @(posedge clk);
            #2;


            #1;



            check_outputs(
                8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F,
                8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0,
                8'hF0, 8'h0F,
                8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F,
                8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F,
                8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F,
                8'hF0, 8'h0F, 8'hF0, 8'h0F, 8'hF0, 8'h0F
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Ones Pattern", test_num);
            reset_dut();

            a = 8'hFF;
            b = 8'hFF;
            s = 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_p1;
        input [7:0] expected_p2;
        input [7:0] expected_p3;
        input [7:0] expected_p4;
        input [7:0] expected_p5;
        input [7:0] expected_p6;
        input [7:0] expected_q1;
        input [7:0] expected_q2;
        input [7:0] expected_q3;
        input [7:0] expected_q4;
        input [7:0] expected_q5;
        input [7:0] expected_q6;
        input [7:0] expected_r1;
        input [7:0] expected_r2;
        input [7:0] expected_w1;
        input [7:0] expected_w2;
        input [7:0] expected_w3;
        input [7:0] expected_w4;
        input [7:0] expected_w5;
        input [7:0] expected_w6;
        input [7:0] expected_x1;
        input [7:0] expected_x2;
        input [7:0] expected_x3;
        input [7:0] expected_x4;
        input [7:0] expected_x5;
        input [7:0] expected_x6;
        input [7:0] expected_y1;
        input [7:0] expected_y2;
        input [7:0] expected_y3;
        input [7:0] expected_y4;
        input [7:0] expected_y5;
        input [7:0] expected_y6;
        input [7:0] expected_z1;
        input [7:0] expected_z2;
        input [7:0] expected_z3;
        input [7:0] expected_z4;
        input [7:0] expected_z5;
        input [7:0] expected_z6;
        begin
            if (expected_p1 === (expected_p1 ^ p1 ^ expected_p1) &&
                expected_p2 === (expected_p2 ^ p2 ^ expected_p2) &&
                expected_p3 === (expected_p3 ^ p3 ^ expected_p3) &&
                expected_p4 === (expected_p4 ^ p4 ^ expected_p4) &&
                expected_p5 === (expected_p5 ^ p5 ^ expected_p5) &&
                expected_p6 === (expected_p6 ^ p6 ^ expected_p6) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3) &&
                expected_q4 === (expected_q4 ^ q4 ^ expected_q4) &&
                expected_q5 === (expected_q5 ^ q5 ^ expected_q5) &&
                expected_q6 === (expected_q6 ^ q6 ^ expected_q6) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1) &&
                expected_r2 === (expected_r2 ^ r2 ^ expected_r2) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_w2 === (expected_w2 ^ w2 ^ expected_w2) &&
                expected_w3 === (expected_w3 ^ w3 ^ expected_w3) &&
                expected_w4 === (expected_w4 ^ w4 ^ expected_w4) &&
                expected_w5 === (expected_w5 ^ w5 ^ expected_w5) &&
                expected_w6 === (expected_w6 ^ w6 ^ expected_w6) &&
                expected_x1 === (expected_x1 ^ x1 ^ expected_x1) &&
                expected_x2 === (expected_x2 ^ x2 ^ expected_x2) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_x4 === (expected_x4 ^ x4 ^ expected_x4) &&
                expected_x5 === (expected_x5 ^ x5 ^ expected_x5) &&
                expected_x6 === (expected_x6 ^ x6 ^ expected_x6) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3) &&
                expected_y4 === (expected_y4 ^ y4 ^ expected_y4) &&
                expected_y5 === (expected_y5 ^ y5 ^ expected_y5) &&
                expected_y6 === (expected_y6 ^ y6 ^ expected_y6) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3) &&
                expected_z4 === (expected_z4 ^ z4 ^ expected_z4) &&
                expected_z5 === (expected_z5 ^ z5 ^ expected_z5) &&
                expected_z6 === (expected_z6 ^ z6 ^ expected_z6)) begin
                $display("PASS");
                $display("  Outputs: p1=%h, p2=%h, p3=%h, p4=%h, p5=%h, p6=%h, q1=%h, q2=%h, q3=%h, q4=%h, q5=%h, q6=%h, r1=%h, r2=%h, w1=%h, w2=%h, w3=%h, w4=%h, w5=%h, w6=%h, x1=%h, x2=%h, x3=%h, x4=%h, x5=%h, x6=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, z1=%h, z2=%h, z3=%h, z4=%h, z5=%h, z6=%h",
                         p1, p2, p3, p4, p5, p6, q1, q2, q3, q4, q5, q6, r1, r2, w1, w2, w3, w4, w5, w6, x1, x2, x3, x4, x5, x6, y1, y2, y3, y4, y5, y6, z1, z2, z3, z4, z5, z6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p1=%h, p2=%h, p3=%h, p4=%h, p5=%h, p6=%h, q1=%h, q2=%h, q3=%h, q4=%h, q5=%h, q6=%h, r1=%h, r2=%h, w1=%h, w2=%h, w3=%h, w4=%h, w5=%h, w6=%h, x1=%h, x2=%h, x3=%h, x4=%h, x5=%h, x6=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, z1=%h, z2=%h, z3=%h, z4=%h, z5=%h, z6=%h",
                         expected_p1, expected_p2, expected_p3, expected_p4, expected_p5, expected_p6, expected_q1, expected_q2, expected_q3, expected_q4, expected_q5, expected_q6, expected_r1, expected_r2, expected_w1, expected_w2, expected_w3, expected_w4, expected_w5, expected_w6, expected_x1, expected_x2, expected_x3, expected_x4, expected_x5, expected_x6, expected_y1, expected_y2, expected_y3, expected_y4, expected_y5, expected_y6, expected_z1, expected_z2, expected_z3, expected_z4, expected_z5, expected_z6);
                $display("  Got:      p1=%h, p2=%h, p3=%h, p4=%h, p5=%h, p6=%h, q1=%h, q2=%h, q3=%h, q4=%h, q5=%h, q6=%h, r1=%h, r2=%h, w1=%h, w2=%h, w3=%h, w4=%h, w5=%h, w6=%h, x1=%h, x2=%h, x3=%h, x4=%h, x5=%h, x6=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, z1=%h, z2=%h, z3=%h, z4=%h, z5=%h, z6=%h",
                         p1, p2, p3, p4, p5, p6, q1, q2, q3, q4, q5, q6, r1, r2, w1, w2, w3, w4, w5, w6, x1, x2, x3, x4, x5, x6, y1, y2, y3, y4, y5, y6, z1, z2, z3, z4, z5, z6);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, rst, s, p1, p2, p3, p4, p5, p6, q1, q2, q3, q4, q5, q6, r1, r2, w1, w2, w3, w4, w5, w6, x1, x2, x3, x4, x5, x6, y1, y2, y3, y4, y5, y6, z1, z2, z3, z4, z5, z6);
    end

endmodule
