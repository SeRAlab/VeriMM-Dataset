`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg DE;
    reg SCD;
    reg SCE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .DE(DE),
        .SCD(SCD),
        .SCE(SCE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D    = 0;
            DE   = 0;
            SCD  = 0;
            SCE  = 0;
            VPWR = 0;
            VGND = 0;
            VPB  = 0;
            VNB  = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs Low", test_num);
            reset_dut();
            D    = 0;
            DE   = 0;
            SCD  = 0;
            SCE  = 0;
            VPWR = 0;
            VGND = 0;
            VPB  = 0;
            VNB  = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs High", test_num);
            reset_dut();
            D    = 1;
            DE   = 1;
            SCD  = 1;
            SCE  = 1;
            VPWR = 1;
            VGND = 1;
            VPB  = 1;
            VNB  = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data High, others Low (Indeterminate)", test_num);
            reset_dut();
            D    = 1;
            DE   = 0;
            SCD  = 0;
            SCE  = 0;
            VPWR = 0;
            VGND = 0;
            VPB  = 0;
            VNB  = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'bx, 1'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Controls High, Power Low (Indeterminate)", test_num);
            reset_dut();
            D    = 1;
            DE   = 1;
            SCD  = 1;
            SCE  = 1;
            VPWR = 0;
            VGND = 0;
            VPB  = 0;
            VNB  = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'bx, 1'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All High except VNB (Indeterminate)", test_num);
            reset_dut();
            D    = 1;
            DE   = 1;
            SCD  = 1;
            SCE  = 1;
            VPWR = 1;
            VGND = 1;
            VPB  = 1;
            VNB  = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'bx, 1'bx);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transition High to Low", test_num);
            reset_dut();

            D=1; DE=1; SCD=1; SCE=1; VPWR=1; VGND=1; VPB=1; VNB=1;
            @(posedge CLK);
            #1;

            D=0; DE=0; SCD=0; SCE=0; VPWR=0; VGND=0; VPB=0; VNB=0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Typical Power Setup (VPWR=1, VGND=0) (Indeterminate)", test_num);
            reset_dut();
            D    = 0;
            DE   = 0;
            SCD  = 0;
            SCE  = 0;
            VPWR = 1;
            VGND = 0;
            VPB  = 1;
            VNB  = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'bx, 1'bx);
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
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,CLK, D, DE, SCD, SCE, VGND, VNB, VPB, VPWR, Q, Q_N);
    end

endmodule
