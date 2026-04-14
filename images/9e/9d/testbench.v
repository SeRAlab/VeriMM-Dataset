`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg SCD;
    reg SCE;
    reg SET_B;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .SCD(SCD),
        .SCE(SCE),
        .SET_B(SET_B),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        D = 0;
        SCD = 0;
        SCE = 0;
        SET_B = 1;
        EN = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: EN=0 (Reset to Low regardless of other inputs)");
        reset_dut();
        D = 1; SET_B = 0; SCD = 1; SCE = 1; EN = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: EN=1, SET_B=0 (Set output High)");
        reset_dut();
        EN = 1; SET_B = 0; D = 0; SCD = 0; SCE = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Normal operation (SCE=1, D=1)");
        reset_dut();
        EN = 1; SET_B = 1; SCE = 1; D = 1; SCD = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Normal operation (SCE=1, D=0)");
        reset_dut();

        EN = 1; SET_B = 0;
        @(posedge CLK);
        #1;
        EN = 1; SET_B = 1; SCE = 1; D = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Conditional operation (SCE=0, SCD=1)");
        reset_dut();
        EN = 1; SET_B = 1; SCE = 0; SCD = 1; D = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Conditional operation (SCE=0, SCD=0)");
        reset_dut();

        EN = 1; SET_B = 0;
        @(posedge CLK);
        #1;
        EN = 1; SET_B = 1; SCE = 0; SCD = 0; D = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Priority check (EN=0 should override SET_B=0)");
        reset_dut();
        EN = 0; SET_B = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Running Testcase 008: Priority check (SET_B=0 should override SCE/D)");
        reset_dut();
        EN = 1; SET_B = 0; SCE = 1; D = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
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
        testcase008();
        
        
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
        $dumpvars(0,CLK, D, EN, SCD, SCE, SET_B, Q);
    end

endmodule
