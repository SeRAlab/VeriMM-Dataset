`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DataBus;
    reg [1:0] MuxCtrl;
    reg [4:0] Operation;
    reg [7:0] T;
    reg [7:0] X;
    reg [7:0] Y;
    reg ce;
    reg clk;
    wire [15:0] AX;
    wire Carry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataBus(DataBus),
        .MuxCtrl(MuxCtrl),
        .Operation(Operation),
        .T(T),
        .X(X),
        .Y(Y),
        .ce(ce),
        .clk(clk),
        .AX(AX),
        .Carry(Carry)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            Operation = 5'b00000;
            MuxCtrl = 2'b00;
            DataBus = 8'h00;
            T = 8'h00;
            X = 8'h00;
            Y = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Loading AL and AH registers");
            reset_dut();
            ce = 1;


            Operation = 5'b00001;
            DataBus = 8'hAA;
            @(posedge clk);
            #1;


            Operation = 5'b00010;
            DataBus = 8'h55;
            @(posedge clk);
            #1;

            Operation = 5'b00000;
            #1;

            check_outputs(16'h55AA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verify Chip Enable (ce=0) prevents updates");
            reset_dut();
            ce = 1;
            Operation = 5'b00011;
            DataBus = 8'hFF;
            @(posedge clk);
            #1;


            ce = 0;
            DataBus = 8'h00;
            Operation = 5'b00011;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Arithmetic AL + T (MuxCtrl=0)");
            reset_dut();
            ce = 1;


            Operation = 5'b00001;
            DataBus = 8'h10;
            @(posedge clk);
            #1;


            Operation = 5'b00100;
            MuxCtrl = 2'b00;
            T = 8'h05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0015, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Arithmetic AL + X (MuxCtrl=1)");
            reset_dut();
            ce = 1;


            Operation = 5'b00001;
            DataBus = 8'h20;
            @(posedge clk);
            #1;


            Operation = 5'b00100;
            MuxCtrl = 2'b01;
            X = 8'h11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0031, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Carry bit generation (AL overflow)");
            reset_dut();
            ce = 1;


            Operation = 5'b00001;
            DataBus = 8'hFF;
            @(posedge clk);
            #1;


            Operation = 5'b00100;
            MuxCtrl = 2'b10;
            Y = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Complex calculation (AH=Base, AL=Offset)");
            reset_dut();
            ce = 1;


            Operation = 5'b00010;
            DataBus = 8'hDE;
            @(posedge clk);
            #1;


            Operation = 5'b00001;
            DataBus = 8'h20;
            @(posedge clk);
            #1;


            Operation = 5'b00100;
            MuxCtrl = 2'b11;
            DataBus = 8'h0F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hDE2F, 1'b0);
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
        input [15:0] expected_AX;
        input expected_Carry;
        begin
            if (expected_AX === (expected_AX ^ AX ^ expected_AX) &&
                expected_Carry === (expected_Carry ^ Carry ^ expected_Carry)) begin
                $display("PASS");
                $display("  Outputs: AX=%h, Carry=%b",
                         AX, Carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AX=%h, Carry=%b",
                         expected_AX, expected_Carry);
                $display("  Got:      AX=%h, Carry=%b",
                         AX, Carry);
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
        $dumpvars(0,DataBus, MuxCtrl, Operation, T, X, Y, ce, clk, AX, Carry);
    end

endmodule
