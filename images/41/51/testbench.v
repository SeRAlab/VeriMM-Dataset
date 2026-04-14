`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pin;
    wire conditioned;
    wire falling;
    wire rising;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pin(pin),
        .conditioned(conditioned),
        .falling(falling),
        .rising(rising)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pin = 0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Rising Edge Detection", test_num);
            reset_dut();

            @(posedge clk);
            #1 pin = 1;




            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Falling Edge Detection", test_num);
            reset_dut();


            @(posedge clk);
            #1 pin = 1;
            repeat (5) @(posedge clk);


            @(posedge clk);
            #1 pin = 0;


            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Steady State High", test_num);
            reset_dut();

            @(posedge clk);
            #1 pin = 1;


            repeat (10) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Steady State Low", test_num);
            reset_dut();

            @(posedge clk);
            #1 pin = 0;

            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0);
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
        input expected_conditioned;
        input expected_falling;
        input expected_rising;
        begin
            if (expected_conditioned === (expected_conditioned ^ conditioned ^ expected_conditioned) &&
                expected_falling === (expected_falling ^ falling ^ expected_falling) &&
                expected_rising === (expected_rising ^ rising ^ expected_rising)) begin
                $display("PASS");
                $display("  Outputs: conditioned=%b, falling=%b, rising=%b",
                         conditioned, falling, rising);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conditioned=%b, falling=%b, rising=%b",
                         expected_conditioned, expected_falling, expected_rising);
                $display("  Got:      conditioned=%b, falling=%b, rising=%b",
                         conditioned, falling, rising);
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
        $dumpvars(0,clk, pin, conditioned, falling, rising);
    end

endmodule
