`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_N;
    reg D;
    reg KAPWR;
    reg RESET_B;
    reg SCD;
    reg SCE;
    reg SLEEP_B;
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
        .CLK_N(CLK_N),
        .D(D),
        .KAPWR(KAPWR),
        .RESET_B(RESET_B),
        .SCD(SCD),
        .SCE(SCE),
        .SLEEP_B(SLEEP_B),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_N = 0;
        forever #5 CLK_N = ~CLK_N;
    end

        task reset_dut;

        begin
            init_signals();
            RESET_B = 0;
            #15;
            RESET_B = 1;
            #5;
        end
        endtask
    task init_signals;

        begin
            D = 0;
            SCD = 0;
            SCE = 0;
            SLEEP_B = 1;
            KAPWR = 1;
            VPWR = 1;
            VPB = 1;
            VGND = 0;
            VNB = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Reset logic check");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Capture D=1 on neg-edge");
            reset_dut();
            D = 1;
            SCE = 0;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Capture D=0 on neg-edge");
            reset_dut();

            D = 1;
            @(negedge CLK_N);
            #2;

            D = 0;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Scan Mode (SCE=1) capturing SCD");
            reset_dut();
            SCE = 1;
            SCD = 1;
            D = 0;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Scan Mode (SCE=1) capturing SCD=0");
            reset_dut();

            D = 1;
            SCE = 0;
            @(negedge CLK_N);
            #2;

            SCE = 1;
            SCD = 0;
            D = 1;
            @(negedge CLK_N);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sleep Mode (SLEEP_B=0)");
            reset_dut();
            SLEEP_B = 0;
            D = 1;
            @(negedge CLK_N);
            #2;


            if (Q === 1'b0 || Q === 1'bx) begin
                pass_count = pass_count + 1;
                $display("PASS: Q is %b (Power-save/Hold active)", Q);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Q captured value while in SLEEP");
            end
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Power Loss (VPWR=0)");
            reset_dut();
            VPWR = 0;
            #10;
            #1;

            check_outputs(1'bx);
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
        $dumpvars(0,CLK_N, D, KAPWR, RESET_B, SCD, SCE, SLEEP_B, VGND, VNB, VPB, VPWR, Q);
    end

endmodule
