`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
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
        .product(product)
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
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 0 * 0", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd0;
            b <= 4'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 15 * 15", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd15;
            b <= 4'd15;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 12 * 1", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd12;
            b <= 4'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 3 * 4", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd3;
            b <= 4'd4;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 7 * 9", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd7;
            b <= 4'd9;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd63);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 10 * 0", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd10;
            b <= 4'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 8 * 8", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd8;
            b <= 4'd8;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 14 * 2", test_num);
            reset_dut();
            @(negedge clk);
            a <= 4'd14;
            b <= 4'd2;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd28);
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
        $dumpvars(0,a, b, clk, product);
    end

endmodule
