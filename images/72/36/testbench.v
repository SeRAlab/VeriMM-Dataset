`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] BitCounter;
    reg Clk;
    reg InProgress;
    reg MdcEn_n;
    reg NoPre;
    reg Reset;
    reg ShiftedBit;
    reg WriteOp;
    wire Mdo;
    wire MdoEn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BitCounter(BitCounter),
        .Clk(Clk),
        .InProgress(InProgress),
        .MdcEn_n(MdcEn_n),
        .NoPre(NoPre),
        .Reset(Reset),
        .ShiftedBit(ShiftedBit),
        .WriteOp(WriteOp),
        .Mdo(Mdo),
        .MdoEn(MdoEn)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            InProgress = 0;
            BitCounter = 0;
            ShiftedBit = 0;
            WriteOp = 0;
            NoPre = 0;
            MdcEn_n = 1;
            repeat (2) @(posedge Clk);
            Reset = 0;
            @(posedge Clk);
        end
        endtask
    task trigger_pipeline;

        begin

            MdcEn_n = 0;
            @(posedge Clk);
            MdcEn_n = 1;
            repeat (2) @(posedge Clk);


            MdcEn_n = 0;
            @(posedge Clk);
            MdcEn_n = 1;
            repeat (2) @(posedge Clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            InProgress = 1;
            WriteOp = 1;
            NoPre = 0;
            BitCounter = 7'd15;
            ShiftedBit = 1;
            trigger_pipeline();
            $display("Testcase %0d: Write Op - Preamble Phase", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            InProgress = 1;
            WriteOp = 1;
            NoPre = 0;
            BitCounter = 7'd52;
            ShiftedBit = 1'b0;
            trigger_pipeline();
            $display("Testcase %0d: Write Op - Data Phase", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            InProgress = 1;
            WriteOp = 0;
            NoPre = 0;
            BitCounter = 7'd40;
            ShiftedBit = 1'b1;
            trigger_pipeline();
            $display("Testcase %0d: Read Op - Address Phase", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            InProgress = 1;
            WriteOp = 0;
            NoPre = 0;
            BitCounter = 7'd55;
            ShiftedBit = 1'b1;
            trigger_pipeline();
            $display("Testcase %0d: Read Op - Data Phase (Tristate check)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            InProgress = 0;
            WriteOp = 1;
            BitCounter = 7'd10;
            trigger_pipeline();
            $display("Testcase %0d: Idle State (InProgress=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            InProgress = 1;
            WriteOp = 1;
            NoPre = 1;
            BitCounter = 7'd10;
            trigger_pipeline();
            $display("Testcase %0d: Write Op - No Preamble (BitCounter in preamble range)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Mdo;
        input expected_MdoEn;
        begin
            if (expected_Mdo === (expected_Mdo ^ Mdo ^ expected_Mdo) &&
                expected_MdoEn === (expected_MdoEn ^ MdoEn ^ expected_MdoEn)) begin
                $display("PASS");
                $display("  Outputs: Mdo=%b, MdoEn=%b",
                         Mdo, MdoEn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mdo=%b, MdoEn=%b",
                         expected_Mdo, expected_MdoEn);
                $display("  Got:      Mdo=%b, MdoEn=%b",
                         Mdo, MdoEn);
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
        $dumpvars(0,BitCounter, Clk, InProgress, MdcEn_n, NoPre, Reset, ShiftedBit, WriteOp, Mdo, MdoEn);
    end

endmodule
