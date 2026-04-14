`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_input;
    reg clk;
    reg coin_input;
    reg reset;
    wire display_output;
    wire product_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_input(button_input),
        .clk(clk),
        .coin_input(coin_input),
        .reset(reset),
        .display_output(display_output),
        .product_output(product_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin_input = 0;
            button_input = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
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


            coin_input = 1;
            @(posedge clk);
            coin_input = 0;
            @(posedge clk);


            button_input = 1;
            @(posedge clk);


            #1;



            check_outputs(1, 1);
            button_input = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            button_input = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 0);
            button_input = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            coin_input = 1;
            @(posedge clk);
            coin_input = 0;


            repeat(3) @(posedge clk);


            #1;



            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            coin_input = 1;
            @(posedge clk);
            coin_input = 0;


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            button_input = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 0);
            button_input = 0;
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
        input expected_display_output;
        input expected_product_output;
        begin
            if (expected_display_output === (expected_display_output ^ display_output ^ expected_display_output) &&
                expected_product_output === (expected_product_output ^ product_output ^ expected_product_output)) begin
                $display("PASS");
                $display("  Outputs: display_output=%b, product_output=%b",
                         display_output, product_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display_output=%b, product_output=%b",
                         expected_display_output, expected_product_output);
                $display("  Got:      display_output=%b, product_output=%b",
                         display_output, product_output);
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
        $dumpvars(0,button_input, clk, coin_input, reset, display_output, product_output);
    end

endmodule
