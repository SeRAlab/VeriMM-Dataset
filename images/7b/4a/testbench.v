`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(2) @(posedge clk_in);
            #2;
            reset = 0;
            repeat(1) @(posedge clk_in);
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

            repeat(100) @(posedge clk_in);

            #1;


            check_outputs(clk_out, 1);
        end
        endtask

    task testcase003;

        reg last_clk_val;
        begin
            test_num = 3;
            reset_dut();

            repeat(100) @(posedge clk_in);
            last_clk_val = clk_out;

            repeat(20) @(posedge clk_in);




            #1;





            check_outputs(clk_out, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(50) @(posedge clk_in);


            reset = 1;
            #20;
            reset = 0;
            #5;


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
        input expected_clk_out;
        input expected_locked;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, locked=%b",
                         clk_out, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, locked=%b",
                         expected_clk_out, expected_locked);
                $display("  Got:      clk_out=%b, locked=%b",
                         clk_out, locked);
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
        $dumpvars(0,clk_in, reset, clk_out, locked);
    end

endmodule
