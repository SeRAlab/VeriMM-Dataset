`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] A;
    reg [8:0] B;
    reg clk;
    wire [14:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .RES(RES)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A <= 0;
        B <= 0;

        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 001: 0 x 0");
        A <= 6'd0;
        B <= 9'd0;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 002: Max A (63) x Max B (511)");
        A <= 6'd63;
        B <= 9'd511;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd32193);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 003: 1 x 1");
        A <= 6'd1;
        B <= 9'd1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 004: 10 x 20");
        A <= 6'd10;
        B <= 9'd20;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd200);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 005: 32 x 256");
        A <= 6'd32;
        B <= 9'd256;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd8192);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 006: 63 x 1");
        A <= 6'd63;
        B <= 9'd1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd63);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 007: 1 x 511");
        A <= 6'd1;
        B <= 9'd511;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd511);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 008: 15 x 100");
        A <= 6'd15;
        B <= 9'd100;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(15'd1500);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [14:0] expected_RES;
        begin
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
        $dumpvars(0,A, B, clk, RES);
    end

endmodule
