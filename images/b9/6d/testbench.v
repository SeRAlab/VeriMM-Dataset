`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg in_en;
    reg rst;
    wire out_en;
    wire [15:0] prdct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .in_en(in_en),
        .rst(rst),
        .out_en(out_en),
        .prdct(prdct)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_en = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_multiplier_test;

        input [7:0] va;
        input [7:0] vb;
        begin
            a = va;
            b = vb;
            @(posedge clk);
            #1 in_en = 1;
            @(posedge clk);
            #1 in_en = 0;



            while (!out_en) begin
                @(posedge clk);
            end


            #2;
            #1;

            check_outputs(1'b1, va * vb);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Small multiplication (15 * 10)");
            reset_dut();
            run_multiplier_test(8'd15, 8'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiplication by zero (0 * 255)");
            reset_dut();
            run_multiplier_test(8'd0, 8'd255);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiplication by one (255 * 1)");
            reset_dut();
            run_multiplier_test(8'd255, 8'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum values (255 * 255)");
            reset_dut();
            run_multiplier_test(8'd255, 8'd255);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Power of two (128 * 2)");
            reset_dut();
            run_multiplier_test(8'd128, 8'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Random medium values (50 * 60)");
            reset_dut();
            run_multiplier_test(8'd50, 8'd60);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Prime numbers (13 * 17)");
            reset_dut();
            run_multiplier_test(8'd13, 8'd17);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating bits (170 * 85)");
            reset_dut();
            run_multiplier_test(8'haa, 8'h55);
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
        input expected_out_en;
        input [15:0] expected_prdct;
        begin
            if (expected_out_en === (expected_out_en ^ out_en ^ expected_out_en) &&
                expected_prdct === (expected_prdct ^ prdct ^ expected_prdct)) begin
                $display("PASS");
                $display("  Outputs: out_en=%b, prdct=%h",
                         out_en, prdct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_en=%b, prdct=%h",
                         expected_out_en, expected_prdct);
                $display("  Got:      out_en=%b, prdct=%h",
                         out_en, prdct);
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
        $dumpvars(0,a, b, clk, in_en, rst, out_en, prdct);
    end

endmodule
