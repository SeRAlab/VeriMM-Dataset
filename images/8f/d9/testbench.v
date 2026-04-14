`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin;
    reg clk;
    reg rst;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .rst(rst),
        .gray(gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        bin = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Reset behavior", test_num);

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Binary 4'b0001 (Dec 1)", test_num);
        bin = 4'b0001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Binary 4'b0011 (Dec 3)", test_num);
        bin = 4'b0011;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Binary 4'b0100 (Dec 4)", test_num);
        bin = 4'b0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Binary 4'b1000 (Dec 8)", test_num);
        bin = 4'b1000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Binary 4'b1111 (Dec 15)", test_num);
        bin = 4'b1111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Binary 4'b1010 (Dec 10)", test_num);
        bin = 4'b1010;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase %0d: Binary 4'b0111 (Dec 7)", test_num);
        bin = 4'b0111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcases1;

    begin
        testcase001();
        testcase002();
        testcase003();
        testcase004();
    end
        endtask

    task testcases2;

    begin
        testcase005();
        testcase006();
        testcase007();
        testcase008();
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
        testcases1();
        testcases2();
        
        
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
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
        $dumpvars(0,bin, clk, rst, gray);
    end

endmodule
