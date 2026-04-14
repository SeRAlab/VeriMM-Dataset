`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_rst;
    wire o_led_b;
    wire o_led_g;
    wire o_led_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_led_b(o_led_b),
        .o_led_g(o_led_g),
        .o_led_r(o_led_r)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst = 1;
            @(posedge i_clk);
            #1;
            i_rst = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset state check");
            reset_dut();



            #1;




            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: State after 1 clock cycle");
            reset_dut();

            @(posedge i_clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: State after 2 clock cycles");
            reset_dut();
            repeat(2) @(posedge i_clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: State after 3 clock cycles");
            reset_dut();
            repeat(3) @(posedge i_clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: State after 4 clock cycles");
            reset_dut();
            repeat(4) @(posedge i_clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: State after 7 clock cycles (All ON)");
            reset_dut();
            repeat(7) @(posedge i_clk);
            #1;

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Mid-operation reset check");
            reset_dut();
            repeat(5) @(posedge i_clk);
            reset_dut();
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
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
        input expected_o_led_b;
        input expected_o_led_g;
        input expected_o_led_r;
        begin
            if (expected_o_led_b === (expected_o_led_b ^ o_led_b ^ expected_o_led_b) &&
                expected_o_led_g === (expected_o_led_g ^ o_led_g ^ expected_o_led_g) &&
                expected_o_led_r === (expected_o_led_r ^ o_led_r ^ expected_o_led_r)) begin
                $display("PASS");
                $display("  Outputs: o_led_b=%b, o_led_g=%b, o_led_r=%b",
                         o_led_b, o_led_g, o_led_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_led_b=%b, o_led_g=%b, o_led_r=%b",
                         expected_o_led_b, expected_o_led_g, expected_o_led_r);
                $display("  Got:      o_led_b=%b, o_led_g=%b, o_led_r=%b",
                         o_led_b, o_led_g, o_led_r);
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
        $dumpvars(0,i_clk, i_rst, o_led_b, o_led_g, o_led_r);
    end

endmodule
