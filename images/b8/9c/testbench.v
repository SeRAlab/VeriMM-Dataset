`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        in = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single LSB change (0 -> 1)", test_num);
        reset_dut();
        in = 8'h01;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single MSB change (0 -> 128)", test_num);
        reset_dut();
        in = 8'h80;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple bits change (0, 1, 2, 3)", test_num);
        reset_dut();
        in = 8'h0F;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Falling edge detection (Bit 5)", test_num);
        reset_dut();
        in = 8'h20;
        @(posedge clk);
        in = 8'h00;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential bit changes", test_num);
        reset_dut();
        in = 8'h01;
        repeat(2) @(posedge clk);
        in = 8'h05;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits toggle (0x55 to 0xAA)", test_num);
        reset_dut();
        in = 8'h55;
        @(posedge clk);
        in = 8'hAA;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check output storage when no change occurs", test_num);
        reset_dut();
        in = 8'h10;
        repeat(2) @(posedge clk);
        in = 8'h10;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(3'd4);
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
        input [2:0] expected_pos;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
        $dumpvars(0,clk, in, reset, pos);
    end

endmodule
