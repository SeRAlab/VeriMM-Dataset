`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] i_0;
    reg [4:0] i_1;
    reg [4:0] i_2;
    reg [1:0] i_3;
    reg [1:0] i_4;
    reg i_5;
    reg reset;
    wire [6:0] o_0;
    wire [6:0] o_1;
    wire [6:0] o_2;
    wire o_3;
    wire o_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_0(i_0),
        .i_1(i_1),
        .i_2(i_2),
        .i_3(i_3),
        .i_4(i_4),
        .i_5(i_5),
        .reset(reset),
        .o_0(o_0),
        .o_1(o_1),
        .o_2(o_2),
        .o_3(o_3),
        .o_4(o_4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d...", test_num);
        reset = 1;
        i_0 = 0; i_1 = 0; i_2 = 0; i_3 = 0; i_4 = 0; i_5 = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h00, 7'h00, 7'h00, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        i_0 = 5'h01; i_1 = 5'h02; i_2 = 5'h03;
        i_3 = 2'b10; i_4 = 2'b01; i_5 = 1'b0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h43, 7'h12, 7'h12, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        i_0 = 5'h05; i_1 = 5'h0A; i_2 = 5'h10;
        i_3 = 2'b11; i_4 = 2'b11; i_5 = 1'b0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h50, 7'h1E, 7'h1E, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        i_0 = 5'h05; i_1 = 5'h0A; i_2 = 5'h10;
        i_3 = 2'b11; i_4 = 2'b11; i_5 = 1'b1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h50, 7'h1F, 7'h1F, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        i_0 = 5'h1F; i_1 = 5'h1F; i_2 = 5'h1F;
        i_3 = 2'b11; i_4 = 2'b11; i_5 = 1'b1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h7F, 7'h1F, 7'h1F, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        i_3 = 2'b11; i_4 = 2'b00; i_5 = 1'b1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h00, 7'h19, 7'h19, 1'b0, 1'b0);
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
        input [6:0] expected_o_0;
        input [6:0] expected_o_1;
        input [6:0] expected_o_2;
        input expected_o_3;
        input expected_o_4;
        begin
            if (expected_o_0 === (expected_o_0 ^ o_0 ^ expected_o_0) &&
                expected_o_1 === (expected_o_1 ^ o_1 ^ expected_o_1) &&
                expected_o_2 === (expected_o_2 ^ o_2 ^ expected_o_2) &&
                expected_o_3 === (expected_o_3 ^ o_3 ^ expected_o_3) &&
                expected_o_4 === (expected_o_4 ^ o_4 ^ expected_o_4)) begin
                $display("PASS");
                $display("  Outputs: o_0=%h, o_1=%h, o_2=%h, o_3=%b, o_4=%b",
                         o_0, o_1, o_2, o_3, o_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_0=%h, o_1=%h, o_2=%h, o_3=%b, o_4=%b",
                         expected_o_0, expected_o_1, expected_o_2, expected_o_3, expected_o_4);
                $display("  Got:      o_0=%h, o_1=%h, o_2=%h, o_3=%b, o_4=%b",
                         o_0, o_1, o_2, o_3, o_4);
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
        $dumpvars(0,clk, i_0, i_1, i_2, i_3, i_4, i_5, reset, o_0, o_1, o_2, o_3, o_4);
    end

endmodule
