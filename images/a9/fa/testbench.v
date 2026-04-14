`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DIN;
    reg GotInterrupt;
    reg [1:0] LoadPC;
    reg [7:0] T;
    reg ce;
    reg clk;
    wire JumpNoOverflow;
    wire [15:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .GotInterrupt(GotInterrupt),
        .LoadPC(LoadPC),
        .T(T),
        .ce(ce),
        .clk(clk),
        .JumpNoOverflow(JumpNoOverflow),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            LoadPC = 2'b00;
            GotInterrupt = 0;
            DIN = 8'h00;
            T = 8'h00;


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ce = 0;
            LoadPC = 2'b01;
            DIN = 8'hAA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ce = 1;
            LoadPC = 2'b01;
            DIN = 8'h55;
            T = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 16'h0055);
        end
        endtask

    task testcase003;

        begin

            ce = 1;
            LoadPC = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0056);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ce = 1;

            LoadPC = 2'b01; DIN = 8'h10;
            @(posedge clk); #1;


            LoadPC = 2'b11;
            T = 8'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0030);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ce = 1;
            LoadPC = 2'b01; DIN = 8'hF0;
            @(posedge clk); #1;

            LoadPC = 2'b11; T = 8'h05;
            #1;
            if (JumpNoOverflow !== 1'b1) $display("JumpNoOverflow Logic Error at Test 5");

            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 16'h00F5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            ce = 1;
            LoadPC = 2'b01; DIN = 8'hFE;
            @(posedge clk); #1;

            LoadPC = 2'b11; T = 8'h05;
            #1;

            #1;


            check_outputs(1'b0, 16'h0103);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            ce = 1;
            GotInterrupt = 1;
            LoadPC = 2'b01; DIN = 8'hAA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 16'h0000);
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
        input expected_JumpNoOverflow;
        input [15:0] expected_PC;
        begin
            if (expected_JumpNoOverflow === (expected_JumpNoOverflow ^ JumpNoOverflow ^ expected_JumpNoOverflow) &&
                expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: JumpNoOverflow=%b, PC=%h",
                         JumpNoOverflow, PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: JumpNoOverflow=%b, PC=%h",
                         expected_JumpNoOverflow, expected_PC);
                $display("  Got:      JumpNoOverflow=%b, PC=%h",
                         JumpNoOverflow, PC);
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
        $dumpvars(0,DIN, GotInterrupt, LoadPC, T, ce, clk, JumpNoOverflow, PC);
    end

endmodule
