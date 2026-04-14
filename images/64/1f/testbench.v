`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
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
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd3;
            b = 4'd2;
            repeat(20) @(posedge clk);
            $display("Test %0d: 3 * 2", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'sd3;
            b = -4'sd2;
            repeat(20) @(posedge clk);
            $display("Test %0d: 3 * -2", test_num);
            #1;

            check_outputs(8'hFA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -4'sd3;
            b = 4'sd2;
            repeat(20) @(posedge clk);
            $display("Test %0d: -3 * 2", test_num);
            #1;

            check_outputs(8'hFA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -4'sd3;
            b = -4'sd4;
            repeat(20) @(posedge clk);
            $display("Test %0d: -3 * -4", test_num);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd0;
            b = -4'sd5;
            repeat(20) @(posedge clk);
            $display("Test %0d: 0 * -5", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'sd7;
            b = 4'sd7;
            repeat(20) @(posedge clk);
            $display("Test %0d: 7 * 7", test_num);
            #1;

            check_outputs(8'h31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -4'sd8;
            b = 4'sd7;
            repeat(20) @(posedge clk);
            $display("Test %0d: -8 * 7", test_num);
            #1;

            check_outputs(8'hC8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -4'sd8;
            b = -4'sd8;
            repeat(20) @(posedge clk);
            $display("Test %0d: -8 * -8", test_num);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'sd1;
            b = -4'sd1;
            repeat(20) @(posedge clk);
            $display("Test %0d: 1 * -1", test_num);
            #1;

            check_outputs(8'hFF);
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
        $dumpvars(0,a, b, clk, reset, product);
    end

endmodule
