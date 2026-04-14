`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] a;
    reg [23:0] b;
    reg clk;
    reg [7:0] ex1;
    reg s1;
    reg s2;
    reg sn;
    wire [23:0] ex2;
    wire [24:0] out;
    wire s;
    wire sn3;
    wire sn4;
    wire sr1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ex1(ex1),
        .s1(s1),
        .s2(s2),
        .sn(sn),
        .ex2(ex2),
        .out(out),
        .s(s),
        .sn3(sn3),
        .sn4(sn4),
        .sr1(sr1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 0;
        b <= 0;
        ex1 <= 0;
        s1 <= 0;
        s2 <= 0;
        sn <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Simple Addition", test_num);
        a <= 24'h000005;
        b <= 24'h00000A;
        ex1 <= 8'h10;
        s1 <= 0;
        s2 <= 0;
        sn <= 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'h000010, 25'h000000F, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Overflow Addition", test_num);
        a <= 24'hFFFFFF;
        b <= 24'h000001;
        ex1 <= 8'hFF;
        s1 <= 0;
        s2 <= 0;
        sn <= 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'h0000FF, 25'h1000000, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Sign XOR (0^1)", test_num);
        a <= 24'h123456;
        b <= 24'h000001;
        ex1 <= 8'hAB;
        s1 <= 0;
        s2 <= 1;
        sn <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'h0000AB, 25'h0123457, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Sign XOR (1^1)", test_num);
        a <= 24'hAAAAAA;
        b <= 24'h555555;
        ex1 <= 8'h00;
        s1 <= 1;
        s2 <= 1;
        sn <= 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'h000000, 25'h0FFFFFF, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Max values and sn control", test_num);
        a <= 24'hFFFFFF;
        b <= 24'hFFFFFF;
        ex1 <= 8'h7F;
        s1 <= 1;
        s2 <= 0;
        sn <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'h00007F, 25'h1FFFFFE, 1'b1, 1'b1, 1'b1, 1'b1);
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
        testcase005();
        
        
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
        input [23:0] expected_ex2;
        input [24:0] expected_out;
        input expected_s;
        input expected_sn3;
        input expected_sn4;
        input expected_sr1;
        begin
            if (expected_ex2 === (expected_ex2 ^ ex2 ^ expected_ex2) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_s === (expected_s ^ s ^ expected_s) &&
                expected_sn3 === (expected_sn3 ^ sn3 ^ expected_sn3) &&
                expected_sn4 === (expected_sn4 ^ sn4 ^ expected_sn4) &&
                expected_sr1 === (expected_sr1 ^ sr1 ^ expected_sr1)) begin
                $display("PASS");
                $display("  Outputs: ex2=%h, out=%h, s=%b, sn3=%b, sn4=%b, sr1=%b",
                         ex2, out, s, sn3, sn4, sr1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex2=%h, out=%h, s=%b, sn3=%b, sn4=%b, sr1=%b",
                         expected_ex2, expected_out, expected_s, expected_sn3, expected_sn4, expected_sr1);
                $display("  Got:      ex2=%h, out=%h, s=%b, sn3=%b, sn4=%b, sr1=%b",
                         ex2, out, s, sn3, sn4, sr1);
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
        $dumpvars(0,a, b, clk, ex1, s1, s2, sn, ex2, out, s, sn3, sn4, sr1);
    end

endmodule
