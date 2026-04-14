`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg clk;
    wire [15:0] product;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .product(product),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition and Multiplication", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            c = 8'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd200, 16'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 8-bit Values", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd65025, 16'd765);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zeros Check", test_num);
            reset_dut();
            a = 8'd0;
            b = 8'd128;
            c = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Product Edge Case (Power of 2)", test_num);
            reset_dut();
            a = 8'd128;
            b = 8'd2;
            c = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd256, 16'd131);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sum Overflow from 8-bit range", test_num);
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            c = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd20000, 16'd350);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Values", test_num);
            reset_dut();
            a = 8'd5;
            b = 8'd255;
            c = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1275, 16'd270);
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
        input [15:0] expected_product;
        input [15:0] expected_sum;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: product=%h, sum=%h",
                         product, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h, sum=%h",
                         expected_product, expected_sum);
                $display("  Got:      product=%h, sum=%h",
                         product, sum);
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
        $dumpvars(0,a, b, c, clk, product, sum);
    end

endmodule
