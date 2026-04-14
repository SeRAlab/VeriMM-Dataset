`timescale 1ns/1ps

module yet_another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg n;
    wire i;
    wire j;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_another_module dut (
        .clock(clock),
        .n(n),
        .i(i),
        .j(j)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            n = 0;


            repeat(2) @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: 5 cycles with n=1...");
            reset_dut();
            n = 1;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: 4 cycles with n=1...");
            reset_dut();
            n = 1;
            repeat(4) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: 2 cycles with n=1...");
            reset_dut();
            n = 1;
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: 1 cycle with n=1...");
            reset_dut();
            n = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: 10 cycles with n=1 (Toggle check)...");
            reset_dut();
            n = 1;
            repeat(10) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("yet_another_module Testbench");
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
        input expected_i;
        input expected_j;
        begin
            if (expected_i === (expected_i ^ i ^ expected_i) &&
                expected_j === (expected_j ^ j ^ expected_j)) begin
                $display("PASS");
                $display("  Outputs: i=%b, j=%b",
                         i, j);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i=%b, j=%b",
                         expected_i, expected_j);
                $display("  Got:      i=%b, j=%b",
                         i, j);
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
        $dumpvars(0,clock, n, i, j);
    end

endmodule
