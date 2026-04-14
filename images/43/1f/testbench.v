`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_a;
    reg button_b;
    reg button_c;
    reg clk;
    reg quarter;
    reg reset;
    wire dispense;
    wire product_a;
    wire product_b;
    wire product_c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_a(button_a),
        .button_b(button_b),
        .button_c(button_c),
        .clk(clk),
        .quarter(quarter),
        .reset(reset),
        .dispense(dispense),
        .product_a(product_a),
        .product_b(product_b),
        .product_c(product_c)
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
            button_c = 0;
            quarter = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Select Product A");
            reset_dut();


            button_a = 1;
            @(posedge clk);
            #1 button_a = 0;


            @(posedge clk);
            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;



            test_num = test_num + 1;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Select Product B");
            reset_dut();


            button_b = 1;
            @(posedge clk);
            #1 button_b = 0;


            @(posedge clk);
            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;


            test_num = test_num + 1;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Select Product C");
            reset_dut();


            button_c = 1;
            @(posedge clk);
            #1 button_c = 0;


            @(posedge clk);
            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;


            test_num = test_num + 1;
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Quarter without button");
            reset_dut();


            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;


            test_num = test_num + 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset after selection");
            reset_dut();


            button_a = 1;
            @(posedge clk);
            #1 button_a = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;

            test_num = test_num + 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Selection persistence");
            reset_dut();


            button_a = 1;
            @(posedge clk);
            #1 button_a = 0;


            button_b = 1;
            @(posedge clk);
            #1 button_b = 0;

            quarter = 1;
            @(posedge clk);
            #1 quarter = 0;

            test_num = test_num + 1;

            #1;


            check_outputs(1, 1, 0, 0);
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
        input expected_dispense;
        input expected_product_a;
        input expected_product_b;
        input expected_product_c;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_product_a === (expected_product_a ^ product_a ^ expected_product_a) &&
                expected_product_b === (expected_product_b ^ product_b ^ expected_product_b) &&
                expected_product_c === (expected_product_c ^ product_c ^ expected_product_c)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, product_a=%b, product_b=%b, product_c=%b",
                         dispense, product_a, product_b, product_c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, product_a=%b, product_b=%b, product_c=%b",
                         expected_dispense, expected_product_a, expected_product_b, expected_product_c);
                $display("  Got:      dispense=%b, product_a=%b, product_b=%b, product_c=%b",
                         dispense, product_a, product_b, product_c);
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
        $dumpvars(0,button_a, button_b, button_c, clk, quarter, reset, dispense, product_a, product_b, product_c);
    end

endmodule
