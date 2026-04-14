`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Enable;
    reg Reset;
    reg [15:0] Seed;
    wire [15:0] Data;
    wire Done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Enable(Enable),
        .Reset(Reset),
        .Seed(Seed),
        .Data(Data),
        .Done(Done)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Enable = 0;
            Seed = 16'h0000;
            #15;
            Reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            Seed = 16'h1234;
            reset_dut();
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Shift Operation", test_num);
            Seed = 16'h1234;
            reset_dut();
            @(negedge Clk);
            Enable = 1;
            @(negedge Clk);
            Enable = 0;
            #1;

            check_outputs(16'h2469, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Enable De-assertion (Done should be 0)", test_num);
            Seed = 16'h1234;
            reset_dut();
            @(negedge Clk);
            Enable = 1;
            @(negedge Clk);
            Enable = 0;
            @(negedge Clk);
            #1;

            check_outputs(16'h2469, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequential Multi-cycle Shifting", test_num);
            Seed = 16'h1234;
            reset_dut();
            @(negedge Clk);
            Enable = 1;
            @(negedge Clk);
            @(negedge Clk);
            Enable = 0;
            #1;

            check_outputs(16'h48D2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Operation with Different Seed (0xFFFF)", test_num);
            Seed = 16'hFFFF;
            reset_dut();
            @(negedge Clk);
            Enable = 1;
            @(negedge Clk);
            Enable = 0;
            #1;

            check_outputs(16'hFFFE, 1'b1);
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
        input [15:0] expected_Data;
        input expected_Done;
        begin
            if (expected_Data === (expected_Data ^ Data ^ expected_Data) &&
                expected_Done === (expected_Done ^ Done ^ expected_Done)) begin
                $display("PASS");
                $display("  Outputs: Data=%h, Done=%b",
                         Data, Done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data=%h, Done=%b",
                         expected_Data, expected_Done);
                $display("  Got:      Data=%h, Done=%b",
                         Data, Done);
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
        $dumpvars(0,Clk, Enable, Reset, Seed, Data, Done);
    end

endmodule
