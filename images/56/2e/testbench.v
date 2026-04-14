`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg inclk0;
    wire c0;
    wire c1;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .inclk0(inclk0),
        .c0(c0),
        .c1(c1),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 0;
            #12;
            areset = 1;
            @(posedge inclk0);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset State Check");
            areset = 0;
            #10;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: First Toggle Check");
            reset_dut();

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Second Toggle Check");
            reset_dut();
            @(posedge inclk0);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Third Toggle Check");
            reset_dut();
            repeat(2) @(posedge inclk0);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Mid-operation Reset Check");
            reset_dut();
            repeat(5) @(posedge inclk0);
            areset = 0;
            #2;
            #1;

            check_outputs(0, 1, 0);
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
        input expected_c0;
        input expected_c1;
        input expected_locked;
        begin
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: c0=%b, c1=%b, locked=%b",
                         c0, c1, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%b, c1=%b, locked=%b",
                         expected_c0, expected_c1, expected_locked);
                $display("  Got:      c0=%b, c1=%b, locked=%b",
                         c0, c1, locked);
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
        $dumpvars(0,areset, inclk0, c0, c1, locked);
    end

endmodule
