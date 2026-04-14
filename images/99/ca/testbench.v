`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin_insert;
    reg product_select;
    reg reset;
    wire dispense;
    wire [3:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin_insert(coin_insert),
        .product_select(product_select),
        .reset(reset),
        .dispense(dispense),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin_insert = 0;
            product_select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            coin_insert = 1;
            @(posedge clk);
            coin_insert = 0;
            @(posedge clk);


            product_select = 1;
            @(posedge clk);
            product_select = 0;


            @(posedge clk);



            #1;




            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            product_select = 1;
            @(posedge clk);
            product_select = 0;

            @(posedge clk);


            #1;



            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            coin_insert = 1;
            @(posedge clk);
            coin_insert = 0;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            repeat(3) begin
                coin_insert = 1;
                @(posedge clk);
                coin_insert = 0;
                @(posedge clk);
            end

            product_select = 1;
            @(posedge clk);
            product_select = 0;

            @(posedge clk);


            #1;



            check_outputs(1'b1, 4'b0001);
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
        input [3:0] expected_display;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, display=%h",
                         dispense, display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, display=%h",
                         expected_dispense, expected_display);
                $display("  Got:      dispense=%b, display=%h",
                         dispense, display);
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
        $dumpvars(0,clk, coin_insert, product_select, reset, dispense, display);
    end

endmodule
