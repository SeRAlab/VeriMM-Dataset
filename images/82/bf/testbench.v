`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in1;
    reg [15:0] freq_div;
    wire clk_out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in1(clk_in1),
        .freq_div(freq_div),
        .clk_out1(clk_out1)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in1 = 0;
        forever #5 clk_in1 = ~clk_in1;
    end

        task reset_dut;

        begin
            freq_div = 16'd0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 2, waiting for 1st toggle", test_num);
            reset_dut();
            freq_div = 16'd2;
            repeat(2) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 2, waiting for 2nd toggle", test_num);
            reset_dut();
            freq_div = 16'd2;
            repeat(2) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 4, waiting for 1st toggle", test_num);
            reset_dut();
            freq_div = 16'd4;
            repeat(4) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 4, waiting for 2nd toggle", test_num);
            reset_dut();
            freq_div = 16'd4;
            repeat(4) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 1, waiting for 1st toggle", test_num);
            reset_dut();
            freq_div = 16'd1;
            repeat(1) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 1, waiting for 2nd toggle", test_num);
            reset_dut();
            freq_div = 16'd1;
            repeat(1) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 10, waiting for 1st toggle", test_num);
            reset_dut();
            freq_div = 16'd10;
            repeat(10) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: freq_div = 10, waiting for 2nd toggle", test_num);
            reset_dut();
            freq_div = 16'd10;
            repeat(10) @(posedge clk_in1);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_clk_out1;
        begin
            if (expected_clk_out1 === (expected_clk_out1 ^ clk_out1 ^ expected_clk_out1)) begin
                $display("PASS");
                $display("  Outputs: clk_out1=%b",
                         clk_out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out1=%b",
                         expected_clk_out1);
                $display("  Got:      clk_out1=%b",
                         clk_out1);
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
        $dumpvars(0,clk_in1, freq_div, clk_out1);
    end

endmodule
