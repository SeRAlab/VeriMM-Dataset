`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire flag_U;
    wire flag_V;
    wire flag_W;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flag_U(flag_U),
        .flag_V(flag_V),
        .flag_W(flag_W)
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
            test_num = test_num + 1;
            $display("\nRunning Testcase 001: Checking Initial State (State 0)");
            reset_dut();

            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase 002: Approaching Threshold (Counter < 360)");
            reset_dut();

            repeat (330) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase 003: Terminal State (Counter > 360)");
            reset_dut();

            repeat (50) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_flag_U;
        input expected_flag_V;
        input expected_flag_W;
        begin
            if (expected_flag_U === (expected_flag_U ^ flag_U ^ expected_flag_U) &&
                expected_flag_V === (expected_flag_V ^ flag_V ^ expected_flag_V) &&
                expected_flag_W === (expected_flag_W ^ flag_W ^ expected_flag_W)) begin
                $display("PASS");
                $display("  Outputs: flag_U=%b, flag_V=%b, flag_W=%b",
                         flag_U, flag_V, flag_W);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag_U=%b, flag_V=%b, flag_W=%b",
                         expected_flag_U, expected_flag_V, expected_flag_W);
                $display("  Got:      flag_U=%b, flag_V=%b, flag_W=%b",
                         flag_U, flag_V, flag_W);
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
        $dumpvars(0,clk, flag_U, flag_V, flag_W);
    end

endmodule
