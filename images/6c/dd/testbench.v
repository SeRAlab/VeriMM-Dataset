`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CP;
    reg J;
    reg K;
    reg MR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CP(CP),
        .J(J),
        .K(K),
        .MR(MR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CP = 0;
        forever #5 CP = ~CP;
    end

        task reset_dut;

        begin
            MR = 1;
            J = 0;
            K = 0;
            @(posedge CP);
            #1;
            MR = 0;
            @(posedge CP);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Set (J=1, K=0)");
            reset_dut();
            J = 1;
            K = 0;
            @(posedge CP);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Clear via JK (J=0, K=1)");
            reset_dut();

            J = 1; K = 0;
            @(posedge CP);
            #1;

            J = 0; K = 1;
            @(posedge CP);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold (J=0, K=0)");
            reset_dut();

            J = 1; K = 0;
            @(posedge CP);
            #1;

            J = 0; K = 0;
            @(posedge CP);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggle (0 -> 1)");
            reset_dut();
            J = 1; K = 1;
            @(posedge CP);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Double Toggle (0 -> 1 -> 0)");
            reset_dut();
            J = 1; K = 1;
            @(posedge CP);
            #1;
            @(posedge CP);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: MR Override during Set");
            reset_dut();
            J = 1; K = 0;
            @(posedge CP);
            #1;
            MR = 1;
            #2;
            #1;

            check_outputs(0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,CP, J, K, MR, Q);
    end

endmodule
