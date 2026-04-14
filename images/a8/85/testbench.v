`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Down;
    reg Up;
    reg reset;
    wire [3:0] BCD0;
    wire [3:0] BCD1;
    wire [7:0] BCD_output;
    wire [3:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Down(Down),
        .Up(Up),
        .reset(reset),
        .BCD0(BCD0),
        .BCD1(BCD1),
        .BCD_output(BCD_output),
        .Count(Count)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Up = 0;
            Down = 0;
            @(posedge Clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 8'h00, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            @(posedge Clk);
            #1;
            Up = 0;

            #1;


            check_outputs(4'd1, 4'd0, 8'h01, 4'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            for (i = 0; i < 10; i = i + 1) @(posedge Clk);
            #1;
            Up = 0;

            #1;


            check_outputs(4'd0, 4'd1, 8'h10, 4'd10);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            for (i = 0; i < 15; i = i + 1) @(posedge Clk);
            #1;
            Up = 0;

            #1;


            check_outputs(4'd5, 4'd1, 8'h15, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            repeat(5) @(posedge Clk);
            Up = 0;
            Down = 1;
            repeat(2) @(posedge Clk);
            #1;
            Down = 0;

            #1;


            check_outputs(4'd3, 4'd0, 8'h03, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge Clk);
            Down = 1;
            @(posedge Clk);
            #1;
            Down = 0;

            #1;


            check_outputs(4'd5, 4'd1, 8'h15, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            Down = 1;
            @(posedge Clk);
            #1;
            Up = 0;
            Down = 0;

            #1;


            check_outputs(4'd0, 4'd0, 8'h00, 4'd0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            reset_dut();
            @(negedge Clk);
            Up = 1;
            for (i = 0; i < 16; i = i + 1) @(posedge Clk);
            #1;
            Up = 0;

            #1;


            check_outputs(4'd0, 4'd0, 8'h00, 4'd0);
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
        input [3:0] expected_BCD0;
        input [3:0] expected_BCD1;
        input [7:0] expected_BCD_output;
        input [3:0] expected_Count;
        begin
            if (expected_BCD0 === (expected_BCD0 ^ BCD0 ^ expected_BCD0) &&
                expected_BCD1 === (expected_BCD1 ^ BCD1 ^ expected_BCD1) &&
                expected_BCD_output === (expected_BCD_output ^ BCD_output ^ expected_BCD_output) &&
                expected_Count === (expected_Count ^ Count ^ expected_Count)) begin
                $display("PASS");
                $display("  Outputs: BCD0=%h, BCD1=%h, BCD_output=%h, Count=%h",
                         BCD0, BCD1, BCD_output, Count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD0=%h, BCD1=%h, BCD_output=%h, Count=%h",
                         expected_BCD0, expected_BCD1, expected_BCD_output, expected_Count);
                $display("  Got:      BCD0=%h, BCD1=%h, BCD_output=%h, Count=%h",
                         BCD0, BCD1, BCD_output, Count);
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
        $dumpvars(0,Clk, Down, Up, reset, BCD0, BCD1, BCD_output, Count);
    end

endmodule
