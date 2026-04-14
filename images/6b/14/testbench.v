`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init_done;
    reg reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init_done(init_done),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            init_done = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            init_done = 0;
            repeat(2) @(posedge clk);
            expected_state = 1'b0;
            #1;

            check_outputs("Initial state check (init_done=0)");
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            init_done = 1;
            @(posedge clk);
            #1;
            expected_state = 1'b1;
            #1;

            check_outputs("Transition to WRITE state check");
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            init_done = 1;
            @(posedge clk);
            #1;
            init_done = 0;
            repeat(3) @(posedge clk);
            expected_state = 1'b1;
            #1;

            check_outputs("Persistence in WRITE state check");
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            init_done = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            expected_state = 1'b0;
            #1;

            check_outputs("Reset from WRITE state check");
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, init_done, reset);
    end

endmodule
