`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] encoder_out;
    reg reset;
    wire [1:0] pos;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .encoder_out(encoder_out),
        .reset(reset),
        .pos(pos),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        encoder_out = 4'b0000;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Reset and Zero Input", test_num);
        reset_dut();
        encoder_out = 4'b0000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Input Binary 1", test_num);
        reset_dut();
        encoder_out = 4'b0001;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Input Binary 2", test_num);
        reset_dut();
        encoder_out = 4'b0010;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Input Binary 4", test_num);
        reset_dut();
        encoder_out = 4'b0100;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Input Binary 8", test_num);
        reset_dut();
        encoder_out = 4'b1000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Input Binary 15", test_num);
        reset_dut();
        encoder_out = 4'b1111;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Input Binary 3", test_num);
        reset_dut();
        encoder_out = 4'b0011;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Input Binary 6", test_num);
        reset_dut();
        encoder_out = 4'b0110;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(2'b10, 1'b1);
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
        input [1:0] expected_pos;
        input expected_pwm;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, pwm=%b",
                         pos, pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, pwm=%b",
                         expected_pos, expected_pwm);
                $display("  Got:      pos=%h, pwm=%b",
                         pos, pwm);
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
        $dumpvars(0,clk, encoder_out, reset, pos, pwm);
    end

endmodule
