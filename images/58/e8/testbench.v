`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk)
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
            $display("Reset/Sync completed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Increment 10 cycles");
            reset_dut();

            expected_count = dut.counter + 10;
            repeat (10) @(posedge clk);
            #2;
            #1;

            check_outputs(expected_count);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Increment 100 cycles");
            reset_dut();
            expected_count = dut.counter + 100;
            repeat (100) @(posedge clk);
            #2;
            #1;

            check_outputs(expected_count);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Large increment test (500 cycles)");
            reset_dut();
            expected_count = dut.counter + 500;
            repeat (500) @(posedge clk);
            #2;
            #1;

            check_outputs(expected_count);
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
        $dumpvars(0,clk);
    end

endmodule
