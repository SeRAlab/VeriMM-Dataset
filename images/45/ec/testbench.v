`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [30:0] inw_w31;
    reg [10:0] inx_w11;
    wire [91:0] outy_w92;
    wire [21:0] outz_w22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inw_w31(inw_w31),
        .inx_w11(inx_w11),
        .outy_w92(outy_w92),
        .outz_w22(outz_w22)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            inw_w31 = 31'd0;
            inx_w11 = 11'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task get_expected;

        input [30:0] w;
        input [10:0] x;
        output [91:0] ey;
        output [21:0] ez;
        reg [92:0] full_y;
        begin
            full_y = {3{w}};
            ey = full_y[91:0];
            ez = {2{x}};
        end
        endtask

    task testcase001;

        reg [91:0] exp_y;
        reg [21:0] exp_z;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            inw_w31 = 31'h0;
            inx_w11 = 11'h0;
            repeat(2) @(posedge clk);
            #1;
            get_expected(inw_w31, inx_w11, exp_y, exp_z);
            #1;

            check_outputs(exp_y, exp_z);
        end
        endtask

    task testcase002;

        reg [91:0] exp_y;
        reg [21:0] exp_z;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            inw_w31 = 31'h7FFFFFFF;
            inx_w11 = 11'h7FF;
            repeat(2) @(posedge clk);
            #1;
            get_expected(inw_w31, inx_w11, exp_y, exp_z);
            #1;

            check_outputs(exp_y, exp_z);
        end
        endtask

    task testcase003;

        reg [91:0] exp_y;
        reg [21:0] exp_z;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (Pattern A)", test_num);
            reset_dut();
            inw_w31 = 31'h2AAAAAAA;
            inx_w11 = 11'h2AA;
            repeat(2) @(posedge clk);
            #1;
            get_expected(inw_w31, inx_w11, exp_y, exp_z);
            #1;

            check_outputs(exp_y, exp_z);
        end
        endtask

    task testcase004;

        reg [91:0] exp_y;
        reg [21:0] exp_z;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (Pattern 5)", test_num);
            reset_dut();
            inw_w31 = 31'h55555555;
            inx_w11 = 11'h555;
            repeat(2) @(posedge clk);
            #1;
            get_expected(inw_w31, inx_w11, exp_y, exp_z);
            #1;

            check_outputs(exp_y, exp_z);
        end
        endtask

    task testcase005;

        reg [91:0] exp_y;
        reg [21:0] exp_z;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Random Data Pattern", test_num);
            reset_dut();
            inw_w31 = 31'h12345678;
            inx_w11 = 11'h4D2;
            repeat(2) @(posedge clk);
            #1;
            get_expected(inw_w31, inx_w11, exp_y, exp_z);
            #1;

            check_outputs(exp_y, exp_z);
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
        input [91:0] expected_outy_w92;
        input [21:0] expected_outz_w22;
        begin
            if (expected_outy_w92 === (expected_outy_w92 ^ outy_w92 ^ expected_outy_w92) &&
                expected_outz_w22 === (expected_outz_w22 ^ outz_w22 ^ expected_outz_w22)) begin
                $display("PASS");
                $display("  Outputs: outy_w92=%h, outz_w22=%h",
                         outy_w92, outz_w22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outy_w92=%h, outz_w22=%h",
                         expected_outy_w92, expected_outz_w22);
                $display("  Got:      outy_w92=%h, outz_w22=%h",
                         outy_w92, outz_w22);
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
        $dumpvars(0,clk, inw_w31, inx_w11, outy_w92, outz_w22);
    end

endmodule
