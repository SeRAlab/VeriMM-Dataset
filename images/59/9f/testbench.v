`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg E;
    reg S;
    wire SB_DFF_REG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .D(D),
        .E(E),
        .S(S),
        .SB_DFF_REG(SB_DFF_REG)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            @(negedge C);
            E = 1;
            S = 0;
            D = 0;
            @(negedge C);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Active Set (E=1, S=1)");
            reset_dut();
            @(negedge C);
            E = 1;
            S = 1;
            D = 0;
            @(negedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Data 0 (E=1, S=0, D=0)");
            reset_dut();

            @(negedge C);
            E = 1; S = 1;
            @(negedge C);

            E = 1;
            S = 0;
            D = 0;
            @(negedge C);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Data 1 (E=1, S=0, D=1)");
            reset_dut();
            @(negedge C);
            E = 1;
            S = 0;
            D = 1;
            @(negedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Disable Enable - Hold 0");
            reset_dut();
            @(negedge C);
            E = 0;
            S = 1;
            D = 1;
            @(negedge C);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Disable Enable - Hold 1");
            reset_dut();

            @(negedge C);
            E = 1; S = 1;
            @(negedge C);

            E = 0;
            S = 0;
            D = 0;
            @(negedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Set Priority (S=1, D=0)");
            reset_dut();
            @(negedge C);
            E = 1;
            S = 1;
            D = 0;
            @(negedge C);
            #1;
            #1;

            check_outputs(1);
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
        input expected_SB_DFF_REG;
        begin
            if (expected_SB_DFF_REG === (expected_SB_DFF_REG ^ SB_DFF_REG ^ expected_SB_DFF_REG)) begin
                $display("PASS");
                $display("  Outputs: SB_DFF_REG=%b",
                         SB_DFF_REG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SB_DFF_REG=%b",
                         expected_SB_DFF_REG);
                $display("  Got:      SB_DFF_REG=%b",
                         SB_DFF_REG);
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
        $dumpvars(0,C, D, E, S, SB_DFF_REG);
    end

endmodule
