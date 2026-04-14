`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BSelector;
    reg Enable;
    reg [31:0] ImmValue;
    reg MemRD;
    reg [4:0] Opcode;
    reg [31:0] RValue1;
    reg [31:0] RValue2;
    reg [4:0] Rd;
    reg RegWrite;
    reg Reset;
    reg clk;
    reg memWD;
    wire BSELECTOR;
    wire [31:0] IMMVALUE;
    wire MEMRD;
    wire MEMWD;
    wire [4:0] OPCODE;
    wire [4:0] RD;
    wire REGWRITE;
    wire [31:0] RVALUE1;
    wire [31:0] RVALUE2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BSelector(BSelector),
        .Enable(Enable),
        .ImmValue(ImmValue),
        .MemRD(MemRD),
        .Opcode(Opcode),
        .RValue1(RValue1),
        .RValue2(RValue2),
        .Rd(Rd),
        .RegWrite(RegWrite),
        .Reset(Reset),
        .clk(clk),
        .memWD(memWD),
        .BSELECTOR(BSELECTOR),
        .IMMVALUE(IMMVALUE),
        .MEMRD(MEMRD),
        .MEMWD(MEMWD),
        .OPCODE(OPCODE),
        .RD(RD),
        .REGWRITE(REGWRITE),
        .RVALUE1(RVALUE1),
        .RVALUE2(RVALUE2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Enable = 0;
            Opcode = 0;
            BSelector = 0;
            Rd = 0;
            RValue1 = 0;
            RValue2 = 0;
            ImmValue = 0;
            MemRD = 0;
            memWD = 0;
            RegWrite = 0;
            @(negedge clk);
            Reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);


            Enable = 0;
            Opcode = 5'h1F;
            RValue1 = 32'hAAAA_AAAA;
            Reset = 1;

            @(negedge clk);

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 5'h0, 5'h0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Data Capture (Enable=1)", test_num);
            reset_dut();

            Reset = 0;
            Enable = 1;
            Opcode = 5'h0A;
            BSelector = 1'b1;
            Rd = 5'h05;
            RValue1 = 32'h1234_5678;
            RValue2 = 32'h8765_4321;
            ImmValue = 32'h0000_FFFF;
            MemRD = 1'b1;
            memWD = 1'b0;
            RegWrite = 1'b1;

            @(negedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h0000_FFFF, 1'b1, 1'b0, 5'h0A, 5'h05, 1'b1, 32'h1234_5678, 32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hold (Enable=0)", test_num);


            Enable = 0;
            Opcode = 5'h11;
            RValue1 = 32'hFFFF_FFFF;

            @(negedge clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h0000_FFFF, 1'b1, 1'b0, 5'h0A, 5'h05, 1'b1, 32'h1234_5678, 32'h8765_4321);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture New Data Set", test_num);

            Reset = 0;
            Enable = 1;
            Opcode = 5'h1C;
            BSelector = 1'b0;
            Rd = 5'h1F;
            RValue1 = 32'hDEAD_BEEF;
            RValue2 = 32'hCAFE_BABE;
            ImmValue = 32'h5555_AAAA;
            MemRD = 1'b0;
            memWD = 1'b1;
            RegWrite = 1'b0;

            @(negedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h5555_AAAA, 1'b0, 1'b1, 5'h1C, 5'h1F, 1'b0, 32'hDEAD_BEEF, 32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Enable", test_num);

            Reset = 1;
            Enable = 1;
            Opcode = 5'h01;
            RValue1 = 32'h1111_1111;

            @(negedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 5'h0, 5'h0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Updates", test_num);

            Reset = 0;
            Enable = 1;


            Opcode = 5'h02; Rd = 5'h02; RValue1 = 32'h2;
            @(negedge clk);
            #1;


            Opcode = 5'h03; Rd = 5'h03; RValue1 = 32'h3;
            @(negedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b1, 5'h03, 5'h03, 1'b0, 32'h3, 32'hCAFE_BABE);
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
        input expected_BSELECTOR;
        input [31:0] expected_IMMVALUE;
        input expected_MEMRD;
        input expected_MEMWD;
        input [4:0] expected_OPCODE;
        input [4:0] expected_RD;
        input expected_REGWRITE;
        input [31:0] expected_RVALUE1;
        input [31:0] expected_RVALUE2;
        begin
            if (expected_BSELECTOR === (expected_BSELECTOR ^ BSELECTOR ^ expected_BSELECTOR) &&
                expected_IMMVALUE === (expected_IMMVALUE ^ IMMVALUE ^ expected_IMMVALUE) &&
                expected_MEMRD === (expected_MEMRD ^ MEMRD ^ expected_MEMRD) &&
                expected_MEMWD === (expected_MEMWD ^ MEMWD ^ expected_MEMWD) &&
                expected_OPCODE === (expected_OPCODE ^ OPCODE ^ expected_OPCODE) &&
                expected_RD === (expected_RD ^ RD ^ expected_RD) &&
                expected_REGWRITE === (expected_REGWRITE ^ REGWRITE ^ expected_REGWRITE) &&
                expected_RVALUE1 === (expected_RVALUE1 ^ RVALUE1 ^ expected_RVALUE1) &&
                expected_RVALUE2 === (expected_RVALUE2 ^ RVALUE2 ^ expected_RVALUE2)) begin
                $display("PASS");
                $display("  Outputs: BSELECTOR=%b, IMMVALUE=%h, MEMRD=%b, MEMWD=%b, OPCODE=%h, RD=%h, REGWRITE=%b, RVALUE1=%h, RVALUE2=%h",
                         BSELECTOR, IMMVALUE, MEMRD, MEMWD, OPCODE, RD, REGWRITE, RVALUE1, RVALUE2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BSELECTOR=%b, IMMVALUE=%h, MEMRD=%b, MEMWD=%b, OPCODE=%h, RD=%h, REGWRITE=%b, RVALUE1=%h, RVALUE2=%h",
                         expected_BSELECTOR, expected_IMMVALUE, expected_MEMRD, expected_MEMWD, expected_OPCODE, expected_RD, expected_REGWRITE, expected_RVALUE1, expected_RVALUE2);
                $display("  Got:      BSELECTOR=%b, IMMVALUE=%h, MEMRD=%b, MEMWD=%b, OPCODE=%h, RD=%h, REGWRITE=%b, RVALUE1=%h, RVALUE2=%h",
                         BSELECTOR, IMMVALUE, MEMRD, MEMWD, OPCODE, RD, REGWRITE, RVALUE1, RVALUE2);
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
        $dumpvars(0,BSelector, Enable, ImmValue, MemRD, Opcode, RValue1, RValue2, Rd, RegWrite, Reset, clk, memWD, BSELECTOR, IMMVALUE, MEMRD, MEMWD, OPCODE, RD, REGWRITE, RVALUE1, RVALUE2);
    end

endmodule
