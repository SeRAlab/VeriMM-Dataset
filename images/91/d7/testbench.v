`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg is_signed;
    reg multE;
    wire mult_stall;
    wire [63:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .is_signed(is_signed),
        .multE(multE),
        .mult_stall(mult_stall),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            multE = 0;
            is_signed = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_for_completion;

        begin


            repeat (5) begin
                if (mult_stall) break;
                @(posedge clk);
            end

            while (mult_stall) begin
                @(posedge clk);
            end

            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 32'd12;
            b = 32'd10;
            is_signed = 0;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 001: Unsigned 12 * 10");
            #1;

            check_outputs(0, 64'd120);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            is_signed = 0;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 002: Unsigned Max * Max");

            #1;


            check_outputs(0, 64'hFFFFFFFE00000001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 32'h12345678;
            b = 32'h0;
            is_signed = 0;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 003: Unsigned Multiplied by Zero");
            #1;

            check_outputs(0, 64'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 32'd15;
            b = 32'd3;
            is_signed = 1;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 004: Signed 15 * 3");
            #1;

            check_outputs(0, 64'd45);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = -32'sd5;
            b = 32'sd10;
            is_signed = 1;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 005: Signed -5 * 10");

            #1;


            check_outputs(0, 64'hFFFFFFFFFFFFFFCE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 32'sd20;
            b = -32'sd4;
            is_signed = 1;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 006: Signed 20 * -4");

            #1;


            check_outputs(0, 64'hFFFFFFFFFFFFFFB0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            a = -32'sd10;
            b = -32'sd10;
            is_signed = 1;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 007: Signed -10 * -10");
            #1;

            check_outputs(0, 64'd100);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            a = 32'h80000000;
            b = 32'h00000001;
            is_signed = 1;
            multE = 1;
            @(posedge clk);
            #1 multE = 0;
            wait_for_completion();
            $display("Testcase 008: Signed MinInt * 1");
            #1;

            check_outputs(0, 64'hFFFFFFFF80000000);
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
        input expected_mult_stall;
        input [63:0] expected_s;
        begin
            if (expected_mult_stall === (expected_mult_stall ^ mult_stall ^ expected_mult_stall) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: mult_stall=%b, s=%h",
                         mult_stall, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mult_stall=%b, s=%h",
                         expected_mult_stall, expected_s);
                $display("  Got:      mult_stall=%b, s=%h",
                         mult_stall, s);
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
        $dumpvars(0,a, b, clk, is_signed, multE, mult_stall, s);
    end

endmodule
