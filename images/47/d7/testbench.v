`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arst;
    reg clk;
    reg ena;
    reg [2:0] pos;
    wire [3:0] bin;
    wire [2:0] one_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst(arst),
        .clk(clk),
        .ena(ena),
        .pos(pos),
        .bin(bin),
        .one_bit(one_bit)
    );

    // Clock generation (10ns period)
    initial begin
        arst = 0;
        forever #5 arst = ~arst;
    end

        task reset_dut;

    begin
        arst = 1;
        ena = 0;
        pos = 0;
        #12;
        arst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Checking Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Position input 2 (pos[2]=0)", test_num);
        reset_dut();
        @(posedge clk);
        ena = 1;
        pos = 3'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0010, 3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Position input 3 (Boundary pos[2]=0)", test_num);
        reset_dut();
        @(posedge clk);
        ena = 1;
        pos = 3'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011, 3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Position input 4 (Boundary pos[2]=1)", test_num);
        reset_dut();
        @(posedge clk);
        ena = 1;
        pos = 3'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1100, 3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Maximum position input 7 (pos[2]=1)", test_num);
        reset_dut();
        @(posedge clk);
        ena = 1;
        pos = 3'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111, 3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Enable signal low", test_num);
        reset_dut();
        @(posedge clk);
        ena = 0;
        pos = 3'd5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000, 3'b000);
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
        input [3:0] expected_bin;
        input [2:0] expected_one_bit;
        begin
            if (expected_bin === (expected_bin ^ bin ^ expected_bin) &&
                expected_one_bit === (expected_one_bit ^ one_bit ^ expected_one_bit)) begin
                $display("PASS");
                $display("  Outputs: bin=%h, one_bit=%h",
                         bin, one_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h, one_bit=%h",
                         expected_bin, expected_one_bit);
                $display("  Got:      bin=%h, one_bit=%h",
                         bin, one_bit);
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
        $dumpvars(0,arst, clk, ena, pos, bin, one_bit);
    end

endmodule
