`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ival;
    reg reset;
    reg sysclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ival(ival),
        .reset(reset),
        .sysclk(sysclk)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            ival = 0;
            reset = 1;
            #5;
            reset = 0;
            #20;
            reset = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            expected_out_i = 1'b0;
            #1;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge sysclk);
            ival = 1;
            @(posedge sysclk);
            ival = 0;
            repeat(2) @(posedge sysclk);

            expected_out_i = 1'b1;
            #1;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge sysclk);
            ival = 1;
            repeat(5) @(posedge sysclk);

            expected_out_i = 1'b1;
            #1;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ival = 1;
            @(posedge sysclk);
            reset = 0;
            repeat(2) @(posedge sysclk);

            expected_out_i = 1'b0;
            #1;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ival = 1;
            @(posedge sysclk);
            ival = 0;
            @(posedge sysclk);
            ival = 1;
            @(posedge sysclk);
            ival = 0;
            repeat(4) @(posedge sysclk);

            expected_out_i = 1'b0;
            #1;
            #1;

            check_outputs();
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
        $dumpvars(0,ival, reset, sysclk);
    end

endmodule
