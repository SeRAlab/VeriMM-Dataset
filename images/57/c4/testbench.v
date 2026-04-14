`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] multiplicand;
    reg [3:0] multiplier;
    reg rst;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .rst(rst),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            multiplicand = 0;
            multiplier = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 * 5 = 15", test_num);
            reset_dut();
            multiplicand = 4'd3;
            multiplier = 4'd5;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 15 = 0", test_num);
            reset_dut();
            multiplicand = 4'd0;
            multiplier = 4'd15;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 * 15 = 225", test_num);
            reset_dut();
            multiplicand = 4'd15;
            multiplier = 4'd15;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 * 1 = 1", test_num);
            reset_dut();
            multiplicand = 4'd1;
            multiplier = 4'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 * 10 = 100", test_num);
            reset_dut();
            multiplicand = 4'd10;
            multiplier = 4'd10;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 7 * 8 = 56", test_num);
            reset_dut();
            multiplicand = 4'd7;
            multiplier = 4'd8;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd56);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 12 * 3 = 36", test_num);
            reset_dut();
            multiplicand = 4'd12;
            multiplier = 4'd3;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd36);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 9 * 6 = 54", test_num);
            reset_dut();
            multiplicand = 4'd9;
            multiplier = 4'd6;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd54);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 * 0 = 0", test_num);
            reset_dut();
            multiplicand = 4'd15;
            multiplier = 4'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 * 2 = 10", test_num);
            reset_dut();
            multiplicand = 4'd5;
            multiplier = 4'd2;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd10);
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
        input [7:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,clk, multiplicand, multiplier, rst, product);
    end

endmodule
