`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg E;
    reg ECK;
    reg SE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .E(E),
        .ECK(ECK),
        .SE(SE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        ECK = 0;
        forever #5 ECK = ~ECK;
    end

        task reset_dut;

    begin
        CK = 0;
        E = 0;
        SE = 1;
        @(posedge ECK);
        #1;
        SE = 0;
        @(posedge ECK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Set (SE) High");
        SE = 1;
        E = 0;
        CK = 0;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Enable High, CK Low");
        SE = 0;
        E = 1;
        CK = 0;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Enable High, CK High");

        SE = 0; E = 1; CK = 0;
        @(posedge ECK);
        #1;

        CK = 1;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Enable Low (Hold Q=1)");
        SE = 0;
        E = 0;
        CK = 0;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Enable Low (Hold Q=0)");

        SE = 0; E = 1; CK = 0;
        @(posedge ECK);
        #1;

        E = 0;
        CK = 1;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: SE Priority over E=1 and CK=0");

        SE = 1;
        E = 1;
        CK = 0;
        @(posedge ECK);
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
        $dumpvars(0,CK, E, ECK, SE, Q);
    end

endmodule
