`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
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
        .CLK(CLK),
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
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            SCE = 0;
            D = 0;
            SCD = 0;

            KAPWR = 1;
            VPWR = 1;
            VPB = 1;
            VGND = 0;
            VNB = 0;
            SLEEP_B = 1;


            RESET_B = 0;
            @(posedge CLK);
            #1;
            RESET_B = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Initial Reset - Q should be 0");
            RESET_B = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Load 1 into shift register (SCE=1, D=1)");
            SCE = 1;
            D = 1;
            RESET_B = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            SCE = 1;
            D = 1;
            @(posedge CLK);
            #1;

            SCE = 0;
            D = 0;
            @(posedge CLK);
            @(posedge CLK);
            #2;
            $display("Testcase 003: Hold value (SCE=0, D changed to 0)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            SCE = 1;
            D = 1;
            @(posedge CLK);
            #1;

            RESET_B = 1;
            #1;

            RESET_B = 0;
            #2;
            $display("Testcase 004: Q gated by RESET_B (Reg=1, RESET_B=0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            SCE = 1; D = 1;
            @(posedge CLK);
            #1;

            D = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 005: Load 0 into shift register (SCE=1, D=0)");
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
        $dumpvars(0,CLK, D, KAPWR, RESET_B, SCD, SCE, SLEEP_B, VGND, VNB, VPB, VPWR, Q);
    end

endmodule
