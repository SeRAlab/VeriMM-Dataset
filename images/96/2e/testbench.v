`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [11:0] value;
    wire DATA;
    wire SCLK;
    wire SYNC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .value(value),
        .DATA(DATA),
        .SCLK(SCLK),
        .SYNC(SYNC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            value = 12'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros (12'h000)", test_num);
            reset_dut();
            value = 12'h000;

            repeat(500) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Full Scale (12'hFFF)", test_num);
            reset_dut();
            value = 12'hFFF;
            repeat(500) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Pattern 12'hA5A", test_num);
            reset_dut();
            value = 12'hA5A;
            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Pattern 12'h5A5", test_num);
            reset_dut();
            value = 12'h5A5;
            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mid-point (12'h800)", test_num);
            reset_dut();
            value = 12'h800;
            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Stability during value change", test_num);
            reset_dut();
            value = 12'h123;
            repeat(20) @(posedge clk);
            value = 12'hABC;
            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_DATA;
        input expected_SCLK;
        input expected_SYNC;
        begin
            if (expected_DATA === (expected_DATA ^ DATA ^ expected_DATA) &&
                expected_SCLK === (expected_SCLK ^ SCLK ^ expected_SCLK) &&
                expected_SYNC === (expected_SYNC ^ SYNC ^ expected_SYNC)) begin
                $display("PASS");
                $display("  Outputs: DATA=%b, SCLK=%b, SYNC=%b",
                         DATA, SCLK, SYNC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA=%b, SCLK=%b, SYNC=%b",
                         expected_DATA, expected_SCLK, expected_SYNC);
                $display("  Got:      DATA=%b, SCLK=%b, SYNC=%b",
                         DATA, SCLK, SYNC);
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
        $dumpvars(0,clk, rst, value, DATA, SCLK, SYNC);
    end

endmodule
