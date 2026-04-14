`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] bin_bcd;
    reg clk;
    reg rst;
    wire [3:0] hun;
    wire [3:0] one;
    wire [3:0] ten;
    wire [3:0] tho;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_bcd(bin_bcd),
        .clk(clk),
        .rst(rst),
        .hun(hun),
        .one(one),
        .ten(ten),
        .tho(tho)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bin_bcd = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0", test_num);
            reset_dut();
            bin_bcd = 12'd0;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 9", test_num);
            reset_dut();
            bin_bcd = 12'd9;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd9, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 10", test_num);
            reset_dut();
            bin_bcd = 12'd10;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 123", test_num);
            reset_dut();
            bin_bcd = 12'd123;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd3, 4'd2, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1000", test_num);
            reset_dut();
            bin_bcd = 12'd1000;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2748", test_num);
            reset_dut();
            bin_bcd = 12'd2748;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd7, 4'd8, 4'd4, 4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4095", test_num);
            reset_dut();
            bin_bcd = 12'd4095;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd5, 4'd9, 4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 3999", test_num);
            reset_dut();
            bin_bcd = 12'd3999;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(4'd9, 4'd9, 4'd9, 4'd3);
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
        input [3:0] expected_hun;
        input [3:0] expected_one;
        input [3:0] expected_ten;
        input [3:0] expected_tho;
        begin
            if (expected_hun === (expected_hun ^ hun ^ expected_hun) &&
                expected_one === (expected_one ^ one ^ expected_one) &&
                expected_ten === (expected_ten ^ ten ^ expected_ten) &&
                expected_tho === (expected_tho ^ tho ^ expected_tho)) begin
                $display("PASS");
                $display("  Outputs: hun=%h, one=%h, ten=%h, tho=%h",
                         hun, one, ten, tho);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hun=%h, one=%h, ten=%h, tho=%h",
                         expected_hun, expected_one, expected_ten, expected_tho);
                $display("  Got:      hun=%h, one=%h, ten=%h, tho=%h",
                         hun, one, ten, tho);
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
        $dumpvars(0,bin_bcd, clk, rst, hun, one, ten, tho);
    end

endmodule
