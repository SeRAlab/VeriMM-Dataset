`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg reset;
    wire [2:0] count;
    wire [7:0] gray_out;
    wire [7:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .reset(reset),
        .count(count),
        .gray_out(gray_out),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Increment", test_num);
            reset_dut();
            control = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1, 8'd1, 8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to Mid-point (4)", test_num);
            reset_dut();
            control = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd4, 8'd6, 8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to Max (7)", test_num);
            reset_dut();
            control = 1;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd7, 8'd4, 8'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment Wrap Around", test_num);
            reset_dut();
            control = 1;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement Wrap Down (0 to 7)", test_num);
            reset_dut();
            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd7, 8'd4, 8'd11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Decrements (0 down to 5)", test_num);
            reset_dut();
            control = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd5, 8'd7, 8'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Operations", test_num);
            reset_dut();
            control = 1;
            repeat(3) @(posedge clk);
            control = 0;
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd2, 8'd3, 8'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gray Code Verification for 3", test_num);
            reset_dut();
            control = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd3, 8'd2, 8'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gray Code Verification for 6", test_num);
            reset_dut();
            control = 1;
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd6, 8'd5, 8'd11);
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
        input [2:0] expected_count;
        input [7:0] expected_gray_out;
        input [7:0] expected_sum_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, gray_out=%h, sum_out=%h",
                         count, gray_out, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, gray_out=%h, sum_out=%h",
                         expected_count, expected_gray_out, expected_sum_out);
                $display("  Got:      count=%h, gray_out=%h, sum_out=%h",
                         count, gray_out, sum_out);
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
        $dumpvars(0,clk, control, reset, count, gray_out, sum_out);
    end

endmodule
