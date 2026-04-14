`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [63:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task run_mult;

        input [31:0] val_a;
        input [31:0] val_b;
        begin
            a = val_a;
            b = val_b;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1, 64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Multiplication (12 * 11)", test_num);
            reset_dut();
            run_mult(32'd12, 32'd11);
            #1;

            check_outputs(1, 64'd132);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Multiplication by Zero (500 * 0)", test_num);
            reset_dut();
            run_mult(32'd500, 32'd0);
            #1;

            check_outputs(1, 64'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Identity Property (1 * 1234567)", test_num);
            reset_dut();
            run_mult(32'd1, 32'd1234567);
            #1;

            check_outputs(1, 64'd1234567);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum 32-bit values (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
            reset_dut();

            run_mult(32'hFFFFFFFF, 32'hFFFFFFFF);
            #1;

            check_outputs(1, 64'hFFFFFFFE00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Prime Numbers (7919 * 65537)", test_num);
            reset_dut();
            run_mult(32'd7919, 32'd65537);
            #1;

            check_outputs(1, 64'd518987503);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Powers of 2 (2^16 * 2^15)", test_num);
            reset_dut();
            run_mult(32'h00010000, 32'h00008000);
            #1;

            check_outputs(1, 64'h0000000080000000);
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
        input expected_done;
        input [63:0] expected_p;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: done=%b, p=%h",
                         done, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, p=%h",
                         expected_done, expected_p);
                $display("  Got:      done=%b, p=%h",
                         done, p);
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
        $dumpvars(0,a, b, clk, rst, start, done, p);
    end

endmodule
