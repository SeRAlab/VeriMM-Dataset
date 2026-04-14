`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rst;
    wire [3:0] AN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rst(rst),
        .AN(AN)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clock);
        #2 rst = 0;

        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(10) @(posedge clock);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(15) @(posedge clock);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(16) @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_AN;
        begin
            if (expected_AN === (expected_AN ^ AN ^ expected_AN)) begin
                $display("PASS");
                $display("  Outputs: AN=%h",
                         AN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%h",
                         expected_AN);
                $display("  Got:      AN=%h",
                         AN);
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
        $dumpvars(0,clock, rst, AN);
    end

endmodule
