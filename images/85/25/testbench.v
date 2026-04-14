`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin;
    reg clk;
    wire [3:0] gray;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .gray(gray),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        bin = 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0000 -> 0001", test_num);
        bin = 4'b0001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        bin = 4'b0001;
        @(posedge clk);
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0001 -> 0010", test_num);
        bin = 4'b0010;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0011, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        bin = 4'b0011;
        @(posedge clk);
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0011 -> 0011 (No change)", test_num);
        bin = 4'b0011;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0000 -> 0100", test_num);
        bin = 4'b0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0110, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0000 -> 1000", test_num);
        bin = 4'b1000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1100, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0000 -> 1111", test_num);
        bin = 4'b1111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000, 1'b1);
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
        input [3:0] expected_gray;
        input expected_valid;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: gray=%h, valid=%b",
                         gray, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h, valid=%b",
                         expected_gray, expected_valid);
                $display("  Got:      gray=%h, valid=%b",
                         gray, valid);
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
        $dumpvars(0,bin, clk, gray, valid);
    end

endmodule
