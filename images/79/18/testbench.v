`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Down;
    reg Reset;
    reg Up;
    wire [3:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Down(Down),
        .Reset(Reset),
        .Up(Up),
        .Count(Count)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        Up = 0;
        Down = 0;
        @(posedge Clk);
        #1;
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Up = 1;
        Down = 0;
        repeat(5) @(posedge Clk);
        #1;
        Up = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Up = 0;
        Down = 1;
        repeat(2) @(posedge Clk);
        #1;
        Down = 0;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Up = 1;
        Down = 0;
        repeat(18) @(posedge Clk);
        #1;
        Up = 0;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Up = 1;
        repeat(3) @(posedge Clk);
        #1 Up = 0; Down = 0;
        repeat(3) @(posedge Clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        Up = 1; Down = 0;
        repeat(5) @(posedge Clk);

        #1 Up = 0; Down = 1;
        repeat(3) @(posedge Clk);
        #1 Down = 0;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        Up = 1;
        Down = 1;
        repeat(4) @(posedge Clk);
        #1 Up = 0; Down = 0;



        #1;




        check_outputs(4'h4);
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
        input [3:0] expected_Count;
        begin
            if (expected_Count === (expected_Count ^ Count ^ expected_Count)) begin
                $display("PASS");
                $display("  Outputs: Count=%h",
                         Count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count=%h",
                         expected_Count);
                $display("  Got:      Count=%h",
                         Count);
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
        $dumpvars(0,Clk, Down, Reset, Up, Count);
    end

endmodule
