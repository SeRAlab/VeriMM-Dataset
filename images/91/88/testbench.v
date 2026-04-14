`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg signed_ctrl;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .signed_ctrl(signed_ctrl),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 8'd0;
        b = 8'd0;
        signed_ctrl = 1'b0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        a = 8'd10;
        b = 8'd5;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: 10 * 5 (signed)", test_num);
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        a = 8'd7;
        b = -8'd3;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: 7 * -3 (signed)", test_num);
        #1;

        check_outputs(-16'd21);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        a = -8'd12;
        b = 8'd4;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: -12 * 4 (signed)", test_num);
        #1;

        check_outputs(-16'd48);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        a = -8'd2;
        b = -8'd5;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: -2 * -5 (signed)", test_num);
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        a = 8'h7F;
        b = 8'h7F;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: 127 * 127 (signed)", test_num);
        #1;

        check_outputs(16'd16129);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        a = 8'h80;
        b = 8'h7F;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: -128 * 127 (signed)", test_num);
        #1;

        check_outputs(-16'd16256);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        a = 8'h80;
        b = 8'h80;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: -128 * -128 (signed)", test_num);
        #1;

        check_outputs(16'd16384);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        a = 8'd0;
        b = -8'd100;
        signed_ctrl = 1'b1;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: 0 * -100 (signed)", test_num);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        a = 8'd10;
        b = 8'hFF;
        signed_ctrl = 1'b0;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: 10 * 255 (unsigned b ctrl)", test_num);
        #1;

        check_outputs(16'd2550);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        a = -8'd1;
        b = 8'hFF;
        signed_ctrl = 1'b0;
        repeat(5) @(posedge clk);
        $display("Testcase %03d: -1 * 255 (unsigned b ctrl)", test_num);
        #1;

        check_outputs(-16'd255);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, signed_ctrl, result);
    end

endmodule
