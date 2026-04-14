`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CP;
    reg j;
    reg k;
    reg reset;
    wire y;
    wire ybar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CP(CP),
        .j(j),
        .k(k),
        .reset(reset),
        .y(y),
        .ybar(ybar)
    );

    // Clock generation (10ns period)
    initial begin
        CP = 0;
        forever #5 CP = ~CP;
    end

        task reset_dut;

        begin
            reset = 1;
            j = 0;
            k = 0;
            #12;
            reset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Asynchronous Reset...");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking J=1, K=0 (Set)...");
            reset_dut();
            j = 1;
            k = 0;
            @(negedge CP);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking J=0, K=1 (Reset)...");
            reset_dut();

            j = 1; k = 0;
            @(negedge CP);

            j = 0; k = 1;
            @(negedge CP);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking J=0, K=0 (Hold)...");
            reset_dut();

            j = 1; k = 0;
            @(negedge CP);

            j = 0; k = 0;
            @(negedge CP);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking J=1, K=1 (Toggle 0 -> 1)...");
            reset_dut();
            j = 1; k = 1;
            @(negedge CP);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Checking J=1, K=1 (Toggle 1 -> 0)...");
            reset_dut();

            j = 1; k = 0;
            @(negedge CP);

            j = 1; k = 1;
            @(negedge CP);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Checking Reset while J=1...");
            reset_dut();
            j = 1; k = 0;
            @(negedge CP);
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        testcase007();
        
        
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
        input expected_y;
        input expected_ybar;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_ybar === (expected_ybar ^ ybar ^ expected_ybar)) begin
                $display("PASS");
                $display("  Outputs: y=%b, ybar=%b",
                         y, ybar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b, ybar=%b",
                         expected_y, expected_ybar);
                $display("  Got:      y=%b, ybar=%b",
                         y, ybar);
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
        $dumpvars(0,CP, j, k, reset, y, ybar);
    end

endmodule
