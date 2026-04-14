`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] multiplicand;
    reg [5:0] multiplier;
    reg reset;
    wire [10:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .reset(reset),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            multiplicand = 0;
            multiplier = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 x 0", test_num);
            reset = 1;
            multiplicand = 6'd0;
            multiplier = 6'd0;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1 x 1", test_num);
            reset = 1;
            multiplicand = 6'd1;
            multiplier = 6'd1;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 10 x 5", test_num);
            reset = 1;
            multiplicand = 6'd10;
            multiplier = 6'd5;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 63 x 2", test_num);
            reset = 1;
            multiplicand = 6'd63;
            multiplier = 6'd2;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd126);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 3 x 63", test_num);
            reset = 1;
            multiplicand = 6'd3;
            multiplier = 6'd63;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd189);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 32 x 16", test_num);
            reset = 1;
            multiplicand = 6'd32;
            multiplier = 6'd16;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd512);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 63 x 32", test_num);
            reset = 1;
            multiplicand = 6'd63;
            multiplier = 6'd32;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd2016);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 45 x 0", test_num);
            reset = 1;
            multiplicand = 6'd45;
            multiplier = 6'd0;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 63 x 63 (Truncated to 11-bit)", test_num);
            reset = 1;
            multiplicand = 6'd63;
            multiplier = 6'd63;
            @(posedge clk);
            #1 reset = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(11'd3969 & 11'h7FF);
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
        input [10:0] expected_product;
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
        $dumpvars(0,clk, multiplicand, multiplier, reset, product);
    end

endmodule
