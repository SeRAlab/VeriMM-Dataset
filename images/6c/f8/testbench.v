`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] ReadReg1;
    reg [4:0] ReadReg2;
    reg RegWrite;
    reg [31:0] WriteData;
    reg [4:0] WriteReg;
    reg clock;
    reg [991:0] registers_in;
    reg reset;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [991:0] registers_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .RegWrite(RegWrite),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .clock(clock),
        .registers_in(registers_in),
        .reset(reset),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .registers_out(registers_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ReadReg1 = 0;
            ReadReg2 = 0;
            RegWrite = 0;
            WriteData = 0;
            WriteReg = 0;
            registers_in = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            ReadReg1 = 5'd0;
            ReadReg2 = 5'd1;
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase002;

        reg [991:0] expected_regs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Write and Read (Reg 1)", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd1;
            WriteData = 32'hABCDE001;
            @(posedge clock);
            #1;
            RegWrite = 0;


            ReadReg1 = 5'd1;
            ReadReg2 = 5'd0;

            expected_regs = 0;
            expected_regs[31:0] = 32'hABCDE001;

            #1;
            #1;

            check_outputs(32'hABCDE001, 32'h0, expected_regs);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 Hardwired Zero Check", test_num);
            reset_dut();

            RegWrite = 1;
            WriteReg = 5'd0;
            WriteData = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd0;
            ReadReg2 = 5'd0;

            #1;
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase004;

        reg [991:0] expected_regs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Read (Reg 10 and 20)", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd10;
            WriteData = 32'h10101010;
            @(posedge clock);
            #1;

            WriteReg = 5'd20;
            WriteData = 32'h20202020;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd10;
            ReadReg2 = 5'd20;

            expected_regs = 0;
            expected_regs[(10*32)-1 -: 32] = 32'h10101010;
            expected_regs[(20*32)-1 -: 32] = 32'h20202020;

            #1;
            #1;

            check_outputs(32'h10101010, 32'h20202020, expected_regs);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RegWrite Control Check", test_num);
            reset_dut();

            RegWrite = 0;
            WriteReg = 5'd5;
            WriteData = 32'h55555555;
            @(posedge clock);
            #1;

            ReadReg1 = 5'd5;
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase006;

        reg [991:0] expected_regs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Bus (R31) Check", test_num);
            reset_dut();

            RegWrite = 1;
            WriteReg = 5'd31;
            WriteData = 32'h87654321;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd31;
            ReadReg2 = 5'd0;

            expected_regs = 0;
            expected_regs[991:960] = 32'h87654321;

            #1;
            #1;

            check_outputs(32'h87654321, 32'h0, expected_regs);
        end
        endtask

    task testcase007;

        reg [991:0] expected_regs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Combinational Read Stability", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd2; WriteData = 32'h22222222; @(posedge clock); #1;
            WriteReg = 5'd3; WriteData = 32'h33333333; @(posedge clock); #1;
            RegWrite = 0;


            ReadReg1 = 5'd2; ReadReg2 = 5'd3;
            #2;

            expected_regs = 0;
            expected_regs[(2*32)-1 -: 32] = 32'h22222222;
            expected_regs[(3*32)-1 -: 32] = 32'h33333333;

            #1;


            check_outputs(32'h22222222, 32'h33333333, expected_regs);
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
        input [31:0] expected_ReadData1;
        input [31:0] expected_ReadData2;
        input [991:0] expected_registers_out;
        begin
            if (expected_ReadData1 === (expected_ReadData1 ^ ReadData1 ^ expected_ReadData1) &&
                expected_ReadData2 === (expected_ReadData2 ^ ReadData2 ^ expected_ReadData2) &&
                expected_registers_out === (expected_registers_out ^ registers_out ^ expected_registers_out)) begin
                $display("PASS");
                $display("  Outputs: ReadData1=%h, ReadData2=%h, registers_out=%h",
                         ReadData1, ReadData2, registers_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData1=%h, ReadData2=%h, registers_out=%h",
                         expected_ReadData1, expected_ReadData2, expected_registers_out);
                $display("  Got:      ReadData1=%h, ReadData2=%h, registers_out=%h",
                         ReadData1, ReadData2, registers_out);
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
        $dumpvars(0,ReadReg1, ReadReg2, RegWrite, WriteData, WriteReg, clock, registers_in, reset, ReadData1, ReadData2, registers_out);
    end

endmodule
