`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] In;
    reg Increment;
    reg Load;
    reg Reset;
    wire [3:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .In(In),
        .Increment(Increment),
        .Load(Load),
        .Reset(Reset),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 0;
        Load = 0;
        Increment = 0;
        In = 0;
        @(posedge Clk);
        #1;
        Reset = 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        Load = 1;
        In = 4'b1010;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        Load = 1;
        In = 4'b0101;
        @(posedge Clk);
        #1;
        Load = 0;
        Increment = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        Increment = 1;
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        Load = 1;
        In = 4'b1111;
        @(posedge Clk);
        #1;
        Load = 0;
        Increment = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        Load = 1;
        In = 4'b1111;
        @(posedge Clk);
        #1;
        Reset = 0;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        Load = 1;
        In = 4'b1000;
        Increment = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        Load = 1;
        In = 4'b1100;
        @(posedge Clk);
        #1;
        Load = 0;
        Increment = 0;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'b1100);
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
        input [3:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,Clk, In, Increment, Load, Reset, Out);
    end

endmodule
