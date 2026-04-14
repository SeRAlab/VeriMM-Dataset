`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_a;
    reg button_b;
    reg clk;
    reg reset;
    wire green_a;
    wire green_b;
    wire red_a;
    wire red_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_a(button_a),
        .button_b(button_b),
        .clk(clk),
        .reset(reset),
        .green_a(green_a),
        .green_b(green_b),
        .red_a(red_a),
        .red_b(red_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            button_a = 0;
            button_b = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Light A Green Duration Check", test_num);
            reset_dut();
            button_a = 1;
            @(posedge clk);
            #1 button_a = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Light A Completion Check", test_num);
            reset_dut();
            button_a = 1;
            @(posedge clk);
            #1 button_a = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Light B Green Duration Check", test_num);
            reset_dut();
            button_b = 1;
            @(posedge clk);
            #1 button_b = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Light B Completion Check", test_num);
            reset_dut();
            button_b = 1;
            @(posedge clk);
            #1 button_b = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Simultaneous Request Safety Check", test_num);
            reset_dut();
            button_a = 1;
            button_b = 1;
            @(posedge clk);
            #1 button_a = 0; button_b = 0;
            repeat(2) @(posedge clk);
            #1;


            if (green_a && green_b) begin
                $display("CRITICAL FAILURE: BOTH LIGHTS GREEN");
                #1;

                check_outputs(0, 0, 1, 1);
            end else begin
                $display("Safety passed: only one or zero green lights active.");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Sequential Completion Check", test_num);
            reset_dut();
            button_a = 1;
            button_b = 1;
            @(posedge clk);
            #1 button_a = 0; button_b = 0;
            repeat(25) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 1);
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
        input expected_green_a;
        input expected_green_b;
        input expected_red_a;
        input expected_red_b;
        begin
            if (expected_green_a === (expected_green_a ^ green_a ^ expected_green_a) &&
                expected_green_b === (expected_green_b ^ green_b ^ expected_green_b) &&
                expected_red_a === (expected_red_a ^ red_a ^ expected_red_a) &&
                expected_red_b === (expected_red_b ^ red_b ^ expected_red_b)) begin
                $display("PASS");
                $display("  Outputs: green_a=%b, green_b=%b, red_a=%b, red_b=%b",
                         green_a, green_b, red_a, red_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_a=%b, green_b=%b, red_a=%b, red_b=%b",
                         expected_green_a, expected_green_b, expected_red_a, expected_red_b);
                $display("  Got:      green_a=%b, green_b=%b, red_a=%b, red_b=%b",
                         green_a, green_b, red_a, red_b);
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
        $dumpvars(0,button_a, button_b, clk, reset, green_a, green_b, red_a, red_b);
    end

endmodule
