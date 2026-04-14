`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] afl;
    reg clk;
    wire [31:0] fl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .afl(afl),
        .clk(clk),
        .fl(fl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        afl = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        afl = 32'h3F800000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h3F800000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        afl = 32'h40000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        afl = 32'hBF800000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hBF800000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        afl = 32'h00000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        afl = 32'h80000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        afl = 32'h7F7FFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h7F7FFFFF);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        afl = 32'h7F800000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h7F800000);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        afl = 32'h7FC00000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h7FC00000);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        afl = 32'h40490FDB;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h40490FDB);
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
        testcase009();
        
        
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
        input [31:0] expected_fl;
        begin
            if (expected_fl === (expected_fl ^ fl ^ expected_fl)) begin
                $display("PASS");
                $display("  Outputs: fl=%h",
                         fl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fl=%h",
                         expected_fl);
                $display("  Got:      fl=%h",
                         fl);
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
        $dumpvars(0,afl, clk, fl);
    end

endmodule
