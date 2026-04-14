`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst;
    wire clk_out_200;
    wire clk_out_400;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .rst(rst),
        .clk_out_200(clk_out_200),
        .clk_out_400(clk_out_400)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            @(negedge clk_in);
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: First Transition", test_num);
            reset_dut();
            @(posedge clk_in);
            #1;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Second Transition", test_num);
            reset_dut();
            repeat(2) @(posedge clk_in);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Third Transition", test_num);
            reset_dut();
            repeat(3) @(posedge clk_in);
            #1;

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around Check", test_num);
            reset_dut();
            repeat(4) @(posedge clk_in);
            #1;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();
            repeat(3) @(posedge clk_in);
            rst = 1;
            #10;
            #1;

            check_outputs(0, 0);
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
        input expected_clk_out_200;
        input expected_clk_out_400;
        begin
            if (expected_clk_out_200 === (expected_clk_out_200 ^ clk_out_200 ^ expected_clk_out_200) &&
                expected_clk_out_400 === (expected_clk_out_400 ^ clk_out_400 ^ expected_clk_out_400)) begin
                $display("PASS");
                $display("  Outputs: clk_out_200=%b, clk_out_400=%b",
                         clk_out_200, clk_out_400);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_200=%b, clk_out_400=%b",
                         expected_clk_out_200, expected_clk_out_400);
                $display("  Got:      clk_out_200=%b, clk_out_400=%b",
                         clk_out_200, clk_out_400);
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
        $dumpvars(0,clk_in, rst, clk_out_200, clk_out_400);
    end

endmodule
