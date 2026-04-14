`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg X;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .X(X),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        A = 0;
        forever #5 A = ~A;
    end

        task reset_dut;

        begin
            X = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #10 X = 1; expected_total = expected_total + 1;
            #10 X = 0;


            wait(A == 1);
            #1;
            #1;

            check_outputs(expected_total);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                #10 X = 1; expected_total = expected_total + 1;
                #10 X = 0;
            end

            wait(A == 1);
            #1;
            #1;

            check_outputs(expected_total);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            #50;

            wait(A == 1);
            #1;
            #1;

            check_outputs(expected_total);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wait(A == 0);
            #2;

            X = 1; expected_total = expected_total + 1;
            #5 X = 0;


            wait(A == 1);
            #1;
            #1;

            check_outputs(expected_total);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for (i = 0; i < 20; i = i + 1) begin
                #2 X = 1; expected_total = expected_total + 1;
                #2 X = 0;
            end

            wait(A == 1);
            #1;
            #1;

            check_outputs(expected_total);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,A, X, count);
    end

endmodule
