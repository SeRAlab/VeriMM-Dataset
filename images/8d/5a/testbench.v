`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire done;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .done(done),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 4'd0;
        b <= 4'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task wait_for_done;

    begin

        integer timeout;
        timeout = 0;
        while (!done && timeout < 20) begin
            @(posedge clk);
            timeout = timeout + 1;
        end

        #1;
    end
        endtask

    task testcase001;

    begin
        $display("Test Case 001: 3 * 2");
        reset_dut();
        a <= 4'sd3;
        b <= 4'sd2;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd6);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: 7 * -3");
        reset_dut();
        a <= 4'sd7;
        b <= -4'sd3;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, -8'sd21);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: -5 * 4");
        reset_dut();
        a <= -4'sd5;
        b <= 4'sd4;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, -8'sd20);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: -4 * -4");
        reset_dut();
        a <= -4'sd4;
        b <= -4'sd4;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd16);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: 0 * -8");
        reset_dut();
        a <= 4'sd0;
        b <= -4'sd8;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: -7 * 1");
        reset_dut();
        a <= -4'sd7;
        b <= 4'sd1;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, -8'sd7);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: 7 * 7");
        reset_dut();
        a <= 4'sd7;
        b <= 4'sd7;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd49);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: -8 * -8");
        reset_dut();
        a <= -4'sd8;
        b <= -4'sd8;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd64);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: -8 * 7");
        reset_dut();
        a <= -4'sd8;
        b <= 4'sd7;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, -8'sd56);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: -1 * -1");
        reset_dut();
        a <= -4'sd1;
        b <= -4'sd1;
        @(posedge clk);
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'sd1);
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
        input expected_done;
        input [7:0] expected_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%h",
                         done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%h",
                         expected_done, expected_out);
                $display("  Got:      done=%b, out=%h",
                         done, out);
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
        $dumpvars(0,a, b, clk, done, out);
    end

endmodule
