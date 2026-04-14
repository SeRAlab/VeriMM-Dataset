`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADIVAR;
    reg BCLK;
    reg BRESET;
    reg [31:0] DISP;
    reg FPU_TRAP;
    reg LOAD_PC;
    reg NEW;
    reg NEW_PC;
    reg NEXT_ADR;
    reg NEXT_PCA;
    reg [31:0] PC_NEW;
    reg SAVE_PC;
    reg [2:0] USED;
    reg USER;
    wire [1:0] ALSB;
    wire IC_USER;
    wire [31:0] PC_ARCHI;
    wire [31:0] PC_ICACHE;
    wire [31:0] PC_SAVE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADIVAR(ADIVAR),
        .BCLK(BCLK),
        .BRESET(BRESET),
        .DISP(DISP),
        .FPU_TRAP(FPU_TRAP),
        .LOAD_PC(LOAD_PC),
        .NEW(NEW),
        .NEW_PC(NEW_PC),
        .NEXT_ADR(NEXT_ADR),
        .NEXT_PCA(NEXT_PCA),
        .PC_NEW(PC_NEW),
        .SAVE_PC(SAVE_PC),
        .USED(USED),
        .USER(USER),
        .ALSB(ALSB),
        .IC_USER(IC_USER),
        .PC_ARCHI(PC_ARCHI),
        .PC_ICACHE(PC_ICACHE),
        .PC_SAVE(PC_SAVE)
    );

    // Clock generation (10ns period)
    initial begin
        BCLK = 0;
        forever #5 BCLK = ~BCLK;
    end

        task reset_dut;

        begin
            BRESET = 1;
            ADIVAR = 0;
            DISP = 0;
            FPU_TRAP = 0;
            LOAD_PC = 0;
            NEW = 0;
            NEW_PC = 0;
            NEXT_ADR = 0;
            NEXT_PCA = 0;
            PC_NEW = 0;
            SAVE_PC = 0;
            USED = 0;
            USER = 0;
            @(posedge BCLK);
            #1 BRESET = 0;
            @(posedge BCLK);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load Absolute PC");
            reset_dut();
            LOAD_PC = 1;
            NEW_PC = 1;
            PC_NEW = 32'h12345678;
            @(posedge BCLK);
            #1 LOAD_PC = 0; NEW_PC = 0;

            #1;


            check_outputs(2'b00, 1'b0, 32'h12345678, 32'h12345678, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sequential Increment");
            reset_dut();
            NEXT_ADR = 1;
            USED = 3'd4;
            @(posedge BCLK);
            #1 NEXT_ADR = 0;

            #1;


            check_outputs(2'b00, 1'b0, 32'h4, 32'h4, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Save PC Operation");
            reset_dut();

            LOAD_PC = 1; PC_NEW = 32'hABCDE000;
            @(posedge BCLK);
            #1 LOAD_PC = 0;

            SAVE_PC = 1;
            @(posedge BCLK);
            #1 SAVE_PC = 0;
            #1;

            check_outputs(2'b00, 1'b0, 32'hABCDE000, 32'hABCDE000, 32'hABCDE000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: PC Displacement (Relative Branch)");
            reset_dut();

            LOAD_PC = 1; PC_NEW = 32'h00000100;
            @(posedge BCLK);
            #1 LOAD_PC = 0;

            NEW = 1;
            DISP = 32'h00000020;
            @(posedge BCLK);
            #1 NEW = 0;

            #1;


            check_outputs(2'b00, 1'b0, 32'h00000120, 32'h00000120, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: User Mode Bit Propagation");
            reset_dut();
            USER = 1;
            @(posedge BCLK);

            #1;


            check_outputs(2'b00, 1'b1, 32'h0, 32'h0, 32'h0);
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
        input [1:0] expected_ALSB;
        input expected_IC_USER;
        input [31:0] expected_PC_ARCHI;
        input [31:0] expected_PC_ICACHE;
        input [31:0] expected_PC_SAVE;
        begin
            if (expected_ALSB === (expected_ALSB ^ ALSB ^ expected_ALSB) &&
                expected_IC_USER === (expected_IC_USER ^ IC_USER ^ expected_IC_USER) &&
                expected_PC_ARCHI === (expected_PC_ARCHI ^ PC_ARCHI ^ expected_PC_ARCHI) &&
                expected_PC_ICACHE === (expected_PC_ICACHE ^ PC_ICACHE ^ expected_PC_ICACHE) &&
                expected_PC_SAVE === (expected_PC_SAVE ^ PC_SAVE ^ expected_PC_SAVE)) begin
                $display("PASS");
                $display("  Outputs: ALSB=%h, IC_USER=%b, PC_ARCHI=%h, PC_ICACHE=%h, PC_SAVE=%h",
                         ALSB, IC_USER, PC_ARCHI, PC_ICACHE, PC_SAVE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALSB=%h, IC_USER=%b, PC_ARCHI=%h, PC_ICACHE=%h, PC_SAVE=%h",
                         expected_ALSB, expected_IC_USER, expected_PC_ARCHI, expected_PC_ICACHE, expected_PC_SAVE);
                $display("  Got:      ALSB=%h, IC_USER=%b, PC_ARCHI=%h, PC_ICACHE=%h, PC_SAVE=%h",
                         ALSB, IC_USER, PC_ARCHI, PC_ICACHE, PC_SAVE);
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
        $dumpvars(0,ADIVAR, BCLK, BRESET, DISP, FPU_TRAP, LOAD_PC, NEW, NEW_PC, NEXT_ADR, NEXT_PCA, PC_NEW, SAVE_PC, USED, USER, ALSB, IC_USER, PC_ARCHI, PC_ICACHE, PC_SAVE);
    end

endmodule
