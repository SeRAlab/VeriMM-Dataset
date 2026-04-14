`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: clk=0 -> Y=1");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            #2;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: clk=1 -> Y=0");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Stability check after 5 cycles");
            test_num = test_num + 1;
            reset_dut();

            repeat(5) @(posedge clk);
            @(negedge clk);
            #2;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: High phase check");
            test_num = test_num + 1;
            reset_dut();

            repeat(2) @(posedge clk);
            #2;


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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,clk, Y);
    end

endmodule
