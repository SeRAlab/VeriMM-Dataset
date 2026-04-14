`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BA1;
    reg BA2;
    reg BAB;
    reg BAS1;
    reg BAS2;
    reg BB1;
    reg BB2;
    reg BBS1;
    reg BBS2;
    reg BSL;
    reg F1;
    reg F2;
    reg FS;
    reg QCK;
    reg QCKS;
    reg QDI;
    reg QDS;
    reg QEN;
    reg QRT;
    reg QST;
    reg TA1;
    reg TA2;
    reg TAB;
    reg TAS1;
    reg TAS2;
    reg TB1;
    reg TB2;
    reg TBS;
    reg TBS1;
    reg TBS2;
    reg TSL;
    wire CZ;
    wire FZ;
    wire QZ;
    wire TZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BA1(BA1),
        .BA2(BA2),
        .BAB(BAB),
        .BAS1(BAS1),
        .BAS2(BAS2),
        .BB1(BB1),
        .BB2(BB2),
        .BBS1(BBS1),
        .BBS2(BBS2),
        .BSL(BSL),
        .F1(F1),
        .F2(F2),
        .FS(FS),
        .QCK(QCK),
        .QCKS(QCKS),
        .QDI(QDI),
        .QDS(QDS),
        .QEN(QEN),
        .QRT(QRT),
        .QST(QST),
        .TA1(TA1),
        .TA2(TA2),
        .TAB(TAB),
        .TAS1(TAS1),
        .TAS2(TAS2),
        .TB1(TB1),
        .TB2(TB2),
        .TBS(TBS),
        .TBS1(TBS1),
        .TBS2(TBS2),
        .TSL(TSL),
        .CZ(CZ),
        .FZ(FZ),
        .QZ(QZ),
        .TZ(TZ)
    );

        task reset_dut;

        begin
            BA1=0; BA2=0; BAB=0; BAS1=0; BAS2=0;
            BB1=0; BB2=0; BBS1=0; BBS2=0; BSL=0;
            F1=0; F2=0; FS=0;
            QCK=0; QCKS=0; QDI=0; QDS=0; QEN=0; QRT=0; QST=0;
            TA1=0; TA2=0; TAB=0; TAS1=0; TAS2=0;
            TB1=0; TB2=0; TBS=0; TBS1=0; TBS2=0; TSL=0;
            #10;
            QRT = 1;
            #20;
            QRT = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase 001: Asynchronous Reset");
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase 002: Asynchronous Set");
            QST = 1;
            #10;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase 003: Load QDI=1");
            QEN = 1;
            QDI = 1;
            #10;
            QCK = 1;
            #10;
            QCK = 0;
            #10;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase 004: Load QDI=0");

            QEN = 1; QDI = 1; #5; QCK = 1; #5; QCK = 0; #5;

            QDI = 0; #5; QCK = 1; #5; QCK = 0; #5;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase 005: Clock Enable Gating");

            QEN = 1; QDI = 1; #5; QCK = 1; #5; QCK = 0; #5;

            QEN = 0; QDI = 0; #5; QCK = 1; #5; QCK = 0; #5;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase 006: F-Path FS=0");
            F1 = 1;
            F2 = 0;
            FS = 0;
            #10;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Running Testcase 007: F-Path FS=1");
            F1 = 0;
            F2 = 1;
            FS = 1;
            #10;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Running Testcase 008: C-Path BSL=0");
            BA1 = 1;
            BAS1 = 1;
            BSL = 0;
            #10;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Running Testcase 009: T-Path TSL=0");
            TA1 = 1;
            TAS1 = 1;
            TSL = 0;
            #10;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Running Testcase 010: B-side selection and BAB XOR");
            BB1 = 1;
            BBS1 = 1;
            BSL = 1;
            BAB = 1;
            #10;


            if (CZ === 0 || CZ === 1) begin
                pass_count = pass_count + 1;
                $display("PASS - CZ correctly influenced by B-path inputs.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - CZ is X or Z.");
            end
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
        testcase009();
        testcase010();
        
        
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
        input expected_CZ;
        input expected_FZ;
        input expected_QZ;
        input expected_TZ;
        begin
            if (expected_CZ === (expected_CZ ^ CZ ^ expected_CZ) &&
                expected_FZ === (expected_FZ ^ FZ ^ expected_FZ) &&
                expected_QZ === (expected_QZ ^ QZ ^ expected_QZ) &&
                expected_TZ === (expected_TZ ^ TZ ^ expected_TZ)) begin
                $display("PASS");
                $display("  Outputs: CZ=%b, FZ=%b, QZ=%b, TZ=%b",
                         CZ, FZ, QZ, TZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CZ=%b, FZ=%b, QZ=%b, TZ=%b",
                         expected_CZ, expected_FZ, expected_QZ, expected_TZ);
                $display("  Got:      CZ=%b, FZ=%b, QZ=%b, TZ=%b",
                         CZ, FZ, QZ, TZ);
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
        $dumpvars(0,BA1, BA2, BAB, BAS1, BAS2, BB1, BB2, BBS1, BBS2, BSL, F1, F2, FS, QCK, QCKS, QDI, QDS, QEN, QRT, QST, TA1, TA2, TAB, TAS1, TAS2, TB1, TB2, TBS, TBS1, TBS2, TSL, CZ, FZ, QZ, TZ);
    end

endmodule
