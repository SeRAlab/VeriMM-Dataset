`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [31:0] n;
    reg reset;
    wire isDone;
    wire isFactor;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .n(n),
        .reset(reset),
        .isDone(isDone),
        .isFactor(isFactor),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Division (100 / 10)", test_num);
            n = 32'd100;
            d = 16'd10;
            reset_dut();

            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Non-factor Division (100 / 3)", test_num);
            n = 32'd100;
            d = 16'd3;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 32'd33);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Numerator (1000000 / 500)", test_num);
            n = 32'd1000000;
            d = 16'd500;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 32'd2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by 1 (54321 / 1)", test_num);
            n = 32'd54321;
            d = 16'd1;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 32'd54321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Numerator (0 / 50)", test_num);
            n = 32'd0;
            d = 16'd50;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Denominator > Numerator (50 / 100)", test_num);
            n = 32'd50;
            d = 16'd100;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Range (32'hFFFFFFFF / 16'hFFFF)", test_num);
            n = 32'hFFFFFFFF;
            d = 16'hFFFF;
            reset_dut();
            while (!isDone) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 32'h10001);
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
        input expected_isDone;
        input expected_isFactor;
        input [31:0] expected_q;
        begin
            if (expected_isDone === (expected_isDone ^ isDone ^ expected_isDone) &&
                expected_isFactor === (expected_isFactor ^ isFactor ^ expected_isFactor) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: isDone=%b, isFactor=%b, q=%h",
                         isDone, isFactor, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isDone=%b, isFactor=%b, q=%h",
                         expected_isDone, expected_isFactor, expected_q);
                $display("  Got:      isDone=%b, isFactor=%b, q=%h",
                         isDone, isFactor, q);
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
        $dumpvars(0,clk, d, n, reset, isDone, isFactor, q);
    end

endmodule
