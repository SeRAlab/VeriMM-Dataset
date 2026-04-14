`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [17:0] ref_level;
    reg [17:0] slicer_in;
    wire [1:0] slicer_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ref_level(ref_level),
        .slicer_in(slicer_in),
        .slicer_out(slicer_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            slicer_in = 0;
            ref_level = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Above reference level", test_num);
            ref_level = 18'sd5000;
            slicer_in = 18'sd10000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Positive range", test_num);
            ref_level = 18'sd5000;
            slicer_in = 18'sd2500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Negative range", test_num);
            ref_level = 18'sd5000;
            slicer_in = -18'sd2500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Below reference and negative range", test_num);
            ref_level = 18'sd5000;
            slicer_in = -18'sd10000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Input zero", test_num);
            ref_level = 18'sd5000;
            slicer_in = 18'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Input equals ref", test_num);
            ref_level = 18'sd5000;
            slicer_in = 18'sd5000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Input equals -ref", test_num);
            ref_level = 18'sd5000;
            slicer_in = -18'sd5000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max positive values", test_num);
            ref_level = 18'sd10000;
            slicer_in = 18'sd131071;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max negative values", test_num);
            ref_level = 18'sd10000;
            slicer_in = -18'sd131072;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Small reference level", test_num);
            ref_level = 18'sd1;
            slicer_in = 18'sd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
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
        testcase010();
        
        
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
        input [1:0] expected_slicer_out;
        begin
            if (expected_slicer_out === (expected_slicer_out ^ slicer_out ^ expected_slicer_out)) begin
                $display("PASS");
                $display("  Outputs: slicer_out=%h",
                         slicer_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slicer_out=%h",
                         expected_slicer_out);
                $display("  Got:      slicer_out=%h",
                         slicer_out);
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
        $dumpvars(0,clk, ref_level, slicer_in, slicer_out);
    end

endmodule
