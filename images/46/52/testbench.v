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
            WriteReg = 0;
            WriteData = 0;
            RegWrite = 0;
            registers_in = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ReadReg1 = 5;
            ReadReg2 = 31;
            #5;
            $display("Testcase %0d: Reset State Check", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd1;
            WriteData = 32'hA5A5A5A5;
            @(posedge clock);
            #2 RegWrite = 0;

            ReadReg1 = 5'd1;
            ReadReg2 = 5'd0;
            #5;

            $display("Testcase %0d: Write and Read Reg 1", test_num);

            #1;


            check_outputs(32'hA5A5A5A5, 32'h0, {960'h0, 32'hA5A5A5A5});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            RegWrite = 0;
            WriteReg = 5'd10;
            WriteData = 32'hFFFFFFFF;
            @(posedge clock);
            #2;

            ReadReg1 = 5'd10;
            #5;
            $display("Testcase %0d: Write Enable Check (RegWrite=0)", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd30;
            WriteData = 32'h12345678;
            @(posedge clock);


            WriteReg = 5'd31;
            WriteData = 32'h87654321;
            @(posedge clock);
            #2 RegWrite = 0;

            ReadReg1 = 5'd30;
            ReadReg2 = 5'd31;
            #5;

            $display("Testcase %0d: Dual Read and High-Reg Mapping", test_num);

            #1;


            check_outputs(32'h12345678, 32'h87654321, {32'h87654321, 32'h12345678, 928'h0});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            RegWrite = 1;
            WriteReg = 5'd0;
            WriteData = 32'hFFFFFFFF;
            @(posedge clock);
            #2 RegWrite = 0;

            ReadReg1 = 5'd0;
            #5;

            $display("Testcase %0d: Register 0 Hardwired to Zero Check", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 992'h0);
        end
        endtask

    task testcase006;

        reg [991:0] expected_bus;
        begin
            test_num = 6;
            reset_dut();
            expected_bus = 0;


            RegWrite = 1;
            WriteReg = 5'd1;
            WriteData = 32'h11111111;
            expected_bus[31:0] = 32'h11111111;
            @(posedge clock);


            WriteReg = 5'd2;
            WriteData = 32'h22222222;
            expected_bus[63:32] = 32'h22222222;
            @(posedge clock);

            #2 RegWrite = 0;
            ReadReg1 = 5'd1;
            ReadReg2 = 5'd2;
            #5;

            $display("Testcase %0d: Back-to-back writes and bus verification", test_num);
            #1;

            check_outputs(32'h11111111, 32'h22222222, expected_bus);
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
