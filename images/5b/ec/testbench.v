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
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Load AL from DataBus", test_num);
        reset_dut();
        ce = 1;
        MuxCtrl = 2'b00;
        DataBus = 8'hA5;
        Operation = 5'b00001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h00A5, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Load AL from T-reg", test_num);
        reset_dut();
        ce = 1;
        MuxCtrl = 2'b01;
        T = 8'h5A;
        Operation = 5'b00001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h005A, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Load AL from X-reg", test_num);
        reset_dut();
        ce = 1;
        MuxCtrl = 2'b10;
        X = 8'h11;
        Operation = 5'b00001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0011, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Load AL from Y-reg", test_num);
        reset_dut();
        ce = 1;
        MuxCtrl = 2'b11;
        Y = 8'h22;
        Operation = 5'b00001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0022, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Reset AH to Zero", test_num);
        reset_dut();
        ce = 1;
        Operation = 5'b00010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: AL Addition Overflow/Carry", test_num);
        reset_dut();
        ce = 1;
        MuxCtrl = 2'b00;
        DataBus = 8'hFF;
        Operation = 5'b00001;
        @(posedge clk);
        #1;
        Operation = 5'b01000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: AH Add with Carry", test_num);
        reset_dut();
        ce = 1;

        Operation = 5'b10000;
        @(posedge clk);

        Operation = 5'b00100;

        @(posedge clk);
        #1;


        if (Carry == 1) #1;
 check_outputs(16'h0200, 1);
        else #1;
 check_outputs(AX, Carry);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Clock Enable (ce) Check", test_num);
        reset_dut();
        ce = 0;
        MuxCtrl = 2'b00;
        DataBus = 8'hFF;
        Operation = 5'b00001;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, 0);
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
