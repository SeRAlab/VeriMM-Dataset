`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ByteSelect;
    reg Clk;
    reg [15:0] CtrlData;
    reg [4:0] Fiad;
    reg [1:0] LatchByte;
    reg MdcEn_n;
    reg Mdi;
    reg Reset;
    reg [4:0] Rgad;
    reg WriteOp;
    wire LinkFail;
    wire [15:0] Prsd;
    wire ShiftedBit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ByteSelect(ByteSelect),
        .Clk(Clk),
        .CtrlData(CtrlData),
        .Fiad(Fiad),
        .LatchByte(LatchByte),
        .MdcEn_n(MdcEn_n),
        .Mdi(Mdi),
        .Reset(Reset),
        .Rgad(Rgad),
        .WriteOp(WriteOp),
        .LinkFail(LinkFail),
        .Prsd(Prsd),
        .ShiftedBit(ShiftedBit)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            ByteSelect = 4'b0;
            CtrlData = 16'h0;
            Fiad = 5'b0;
            LatchByte = 2'b0;
            MdcEn_n = 1'b1;
            Mdi = 1'b0;
            Rgad = 5'b0;
            WriteOp = 1'b0;
            repeat(5) @(posedge Clk);
            Reset = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] test_val;
        begin
            reset_dut();
            test_val = 16'hABCD;
            MdcEn_n = 0;


            for (i = 15; i >= 0; i = i - 1) begin
                Mdi = test_val[i];
                @(posedge Clk);
                #1;
            end


            MdcEn_n = 1;
            LatchByte = 2'b01; @(posedge Clk); #1;
            LatchByte = 2'b10; @(posedge Clk); #1;
            LatchByte = 2'b00; @(posedge Clk); #1;


            #1;



            check_outputs(1'b0, 16'hABCD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            WriteOp = 1;
            CtrlData = 16'hF0F0;
            ByteSelect = 4'b0001;


            @(posedge Clk);
            MdcEn_n = 0;


            repeat(1) @(posedge Clk);
            #1;


            #1;



            check_outputs(1'b0, 16'h0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [15:0] status_reg;
        begin
            reset_dut();

            status_reg = 16'b0000_0000_0000_0000;
            MdcEn_n = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                Mdi = status_reg[i];
                @(posedge Clk);
            end


            LatchByte = 2'b11; @(posedge Clk); #1;
            LatchByte = 2'b00; @(posedge Clk); #1;



            #1;




            check_outputs(LinkFail, Prsd, ShiftedBit);
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
        input expected_LinkFail;
        input [15:0] expected_Prsd;
        input expected_ShiftedBit;
        begin
            if (expected_LinkFail === (expected_LinkFail ^ LinkFail ^ expected_LinkFail) &&
                expected_Prsd === (expected_Prsd ^ Prsd ^ expected_Prsd) &&
                expected_ShiftedBit === (expected_ShiftedBit ^ ShiftedBit ^ expected_ShiftedBit)) begin
                $display("PASS");
                $display("  Outputs: LinkFail=%b, Prsd=%h, ShiftedBit=%b",
                         LinkFail, Prsd, ShiftedBit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LinkFail=%b, Prsd=%h, ShiftedBit=%b",
                         expected_LinkFail, expected_Prsd, expected_ShiftedBit);
                $display("  Got:      LinkFail=%b, Prsd=%h, ShiftedBit=%b",
                         LinkFail, Prsd, ShiftedBit);
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
        $dumpvars(0,ByteSelect, Clk, CtrlData, Fiad, LatchByte, MdcEn_n, Mdi, Reset, Rgad, WriteOp, LinkFail, Prsd, ShiftedBit);
    end

endmodule
