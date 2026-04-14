`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg En;
    reg Reset;
    reg Slt;
    wire [63:0] Output0;
    wire [63:0] Output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .En(En),
        .Reset(Reset),
        .Slt(Slt),
        .Output0(Output0),
        .Output1(Output1)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            En = 0;
            Slt = 0;
            @(posedge Clk);
            #1;
            Reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Output0 increment (Slt=0)", test_num);
            reset_dut();
            En = 1;
            Slt = 0;
            repeat (10) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd10, 64'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Output1 increment (Slt=1)", test_num);
            reset_dut();
            En = 1;
            Slt = 1;
            repeat (8) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd8, 64'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Incomplete Output1 cycle", test_num);
            reset_dut();
            En = 1;
            Slt = 1;
            repeat (3) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd3, 64'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Enable signal low check", test_num);
            reset_dut();
            En = 0;
            Slt = 1;
            repeat (10) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Switching Slt mid-operation", test_num);
            reset_dut();
            En = 1;
            Slt = 0;
            repeat (5) @(posedge Clk);
            Slt = 1;
            repeat (4) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd9, 64'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Interrupted Enable mid-cycle", test_num);
            reset_dut();
            En = 1;
            Slt = 1;
            repeat (2) @(posedge Clk);
            En = 0;
            repeat (5) @(posedge Clk);
            En = 1;
            repeat (2) @(posedge Clk);
            #1;
            #1;

            check_outputs(64'd4, 64'd1);
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
        input [63:0] expected_Output0;
        input [63:0] expected_Output1;
        begin
            if (expected_Output0 === (expected_Output0 ^ Output0 ^ expected_Output0) &&
                expected_Output1 === (expected_Output1 ^ Output1 ^ expected_Output1)) begin
                $display("PASS");
                $display("  Outputs: Output0=%h, Output1=%h",
                         Output0, Output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Output0=%h, Output1=%h",
                         expected_Output0, expected_Output1);
                $display("  Got:      Output0=%h, Output1=%h",
                         Output0, Output1);
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
        $dumpvars(0,Clk, En, Reset, Slt, Output0, Output1);
    end

endmodule
