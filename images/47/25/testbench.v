`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg select;
    wire [31:0] OUT1;
    wire [31:0] OUT2;
    wire clkdivided1hz;
    wire clkdivided200hz;
    wire clkselect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .select(select),
        .OUT1(OUT1),
        .OUT2(OUT2),
        .clkdivided1hz(clkdivided1hz),
        .clkdivided200hz(clkdivided200hz),
        .clkselect(clkselect)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            select = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'd0, 32'd0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking increment logic (10 cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(32'd10, 32'd10, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking clkselect with select=1", test_num);
            reset_dut();
            select = 1;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(32'd5, 32'd5, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking counters after 500 cycles", test_num);
            reset_dut();
            select = 0;
            repeat(500) @(posedge clk);
            #2;

            #1;


            check_outputs(32'd500, 32'd500, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking reset during operation", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #2;

            if (OUT1 == 32'd100) begin
                rst = 1;
                #20;
                rst = 0;
                #10;

                #1;


                check_outputs(32'd0, 32'd0, 1'b0, 1'b0, 1'b0);
            end else begin
                $display("Counter did not reach 100, cannot perform mid-count reset check");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_OUT1;
        input [31:0] expected_OUT2;
        input expected_clkdivided1hz;
        input expected_clkdivided200hz;
        input expected_clkselect;
        begin
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1) &&
                expected_OUT2 === (expected_OUT2 ^ OUT2 ^ expected_OUT2) &&
                expected_clkdivided1hz === (expected_clkdivided1hz ^ clkdivided1hz ^ expected_clkdivided1hz) &&
                expected_clkdivided200hz === (expected_clkdivided200hz ^ clkdivided200hz ^ expected_clkdivided200hz) &&
                expected_clkselect === (expected_clkselect ^ clkselect ^ expected_clkselect)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%h, OUT2=%h, clkdivided1hz=%b, clkdivided200hz=%b, clkselect=%b",
                         OUT1, OUT2, clkdivided1hz, clkdivided200hz, clkselect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%h, OUT2=%h, clkdivided1hz=%b, clkdivided200hz=%b, clkselect=%b",
                         expected_OUT1, expected_OUT2, expected_clkdivided1hz, expected_clkdivided200hz, expected_clkselect);
                $display("  Got:      OUT1=%h, OUT2=%h, clkdivided1hz=%b, clkdivided200hz=%b, clkselect=%b",
                         OUT1, OUT2, clkdivided1hz, clkdivided200hz, clkselect);
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
        $dumpvars(0,clk, rst, select, OUT1, OUT2, clkdivided1hz, clkdivided200hz, clkselect);
    end

endmodule
