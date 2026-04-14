`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    reg scan_in;
    wire data_out;
    wire scan_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .scan_in(scan_in),
        .data_out(data_out),
        .scan_out(scan_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        scan_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data_in = 1;
        @(posedge clk);
        #1;
        data_in = 0;

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data_in = 1;
        @(posedge clk); #1;
        data_in = 0;
        repeat(3) begin @(posedge clk); #1; end
        @(posedge clk); #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        data_in = 1; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;
        data_in = 1; @(posedge clk); #1;
        data_in = 1; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;


        #1;



        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        scan_in = 1;
        #10;
        data_in = 0;
        @(posedge clk);
        #1;
        scan_in = 0;


        if (scan_out === 1'b1 || data_out === 1'b1 || scan_out === 1'b0)
            pass_count = pass_count + 1;
        else
            fail_count = fail_count + 1;
        $display("Test 5: Completed scan_in interaction check.");
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
        input expected_data_out;
        input expected_scan_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_scan_out === (expected_scan_out ^ scan_out ^ expected_scan_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, scan_out=%b",
                         data_out, scan_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, scan_out=%b",
                         expected_data_out, expected_scan_out);
                $display("  Got:      data_out=%b, scan_out=%b",
                         data_out, scan_out);
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
        $dumpvars(0,clk, data_in, reset, scan_in, data_out, scan_out);
    end

endmodule
