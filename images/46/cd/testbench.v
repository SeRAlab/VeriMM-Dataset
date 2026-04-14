`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst;
    wire detctd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .detctd(detctd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Valid Sequence Detection");
            reset_dut();
            in = 1; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1;
            #1;
            #1;

            check_outputs(1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Invalid Final Bit");
            reset_dut();
            in = 1; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0;
            #1;
            #1;

            check_outputs(1'b0);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Sequence Interrupted Early");
            reset_dut();
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1;
            #1;
            #1;

            check_outputs(1'b0);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset Mid-Sequence");
            reset_dut();
            in = 1; @(posedge clk);
            in = 1; @(posedge clk);
            rst = 1; @(posedge clk);
            rst = 0;
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1;
            #1;
            #1;

            check_outputs(1'b0);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Continuous Zeros");
            reset_dut();
            in = 0; @(posedge clk);
            in = 0; @(posedge clk);
            in = 0; @(posedge clk);
            in = 0; @(posedge clk);
            in = 0;
            #1;
            #1;

            check_outputs(1'b0);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Pattern after Noise Bits");
            reset_dut();

            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);

            in = 1; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1;
            #1;
            #1;

            check_outputs(1'b1);
            @(posedge clk);
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
        input expected_detctd;
        begin
            if (expected_detctd === (expected_detctd ^ detctd ^ expected_detctd)) begin
                $display("PASS");
                $display("  Outputs: detctd=%b",
                         detctd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detctd=%b",
                         expected_detctd);
                $display("  Got:      detctd=%b",
                         detctd);
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
        $dumpvars(0,clk, in, rst, detctd);
    end

endmodule
