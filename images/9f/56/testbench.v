`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    reg SCD;
    reg SCE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .SCD(SCD),
        .SCE(SCE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
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
        RESET_B = 0;
        VPWR = 1;
        VGND = 0;
        VPB = 1;
        VNB = 0;
        #12;
        RESET_B = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        $display("Testcase 001: Reset Check");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge CLK);
        D = 1;
        SCD = 0;
        SCE = 0;
        @(posedge CLK);
        #1;
        $display("Testcase 002: Data Capture (D=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(posedge CLK);
        D = 1; SCD = 0; SCE = 0;
        @(posedge CLK);

        D = 0;
        @(posedge CLK);
        #1;
        $display("Testcase 003: Data Capture (D=0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(posedge CLK);
        D = 1; SCD = 0; SCE = 0;
        @(posedge CLK);

        SCD = 1;
        SCE = 1;
        D = 0;
        @(posedge CLK);
        #1;
        $display("Testcase 004: Hold Value (Q=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge CLK);
        SCD = 1;
        SCE = 0;
        D = 0;
        @(posedge CLK);
        #1;
        $display("Testcase 005: Set Function (SCD=1, SCE=0)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        @(posedge CLK);
        D = 1; SCD = 0; SCE = 0;
        @(posedge CLK);

        SCD = 0;
        SCE = 1;
        @(posedge CLK);
        #1;
        $display("Testcase 006: Clear Function (SCD=0, SCE=1)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();

        @(posedge CLK);
        D = 0; SCD = 0; SCE = 0;
        @(posedge CLK);

        SCD = 1;
        SCE = 1;
        D = 1;
        @(posedge CLK);
        #1;
        $display("Testcase 007: Hold Value (Q=0)");
        #1;

        check_outputs(1'b0);
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
        $dumpvars(0,CLK, D, RESET_B, SCD, SCE, VGND, VNB, VPB, VPWR, Q);
    end

endmodule
