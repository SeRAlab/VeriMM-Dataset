`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [254:0] in_tree;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [15:0] out_sum;
    wire [7:0] out_tree;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .in_tree(in_tree),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .out_sum(out_sum),
        .out_tree(out_tree)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            in_tree = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h0000;
            in_tree = 255'h0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All zeros", test_num);
            #1;

            check_outputs(8'h00, 8'h00, 16'h0000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'hFFAA;
            in_tree = 255'h0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: High bits non-zero, tree zero", test_num);
            #1;

            check_outputs(8'hFF, 8'hAA, 16'h0000, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h00FF;
            in_tree = 255'hF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: High bits zero, tree non-zero", test_num);
            #1;

            check_outputs(8'h00, 8'hFF, 16'h0000, 8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h1020;
            in_tree = 255'h1F;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Both non-zero addition", test_num);
            #1;

            check_outputs(8'h10, 8'h20, 16'h0015, 8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'hFF00;
            in_tree = {255{1'b1}};
            @(posedge clk);
            #1;
            $display("Testcase %0d: Maximum values bit count and sum", test_num);
            #1;

            check_outputs(8'hFF, 8'h00, 16'h01FE, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h01AB;
            in_tree = 255'b0;
            in_tree[0] = 1;
            in_tree[100] = 1;
            in_tree[254] = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sparse bit counting", test_num);
            #1;

            check_outputs(8'h01, 8'hAB, 16'h0004, 8'h03);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [15:0] expected_out_sum;
        input [7:0] expected_out_tree;
        begin
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_out_tree === (expected_out_tree ^ out_tree ^ expected_out_tree)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h, out_sum=%h, out_tree=%h",
                         out_hi, out_lo, out_sum, out_tree);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h, out_sum=%h, out_tree=%h",
                         expected_out_hi, expected_out_lo, expected_out_sum, expected_out_tree);
                $display("  Got:      out_hi=%h, out_lo=%h, out_sum=%h, out_tree=%h",
                         out_hi, out_lo, out_sum, out_tree);
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
        $dumpvars(0,clk, in, in_tree, out_hi, out_lo, out_sum, out_tree);
    end

endmodule
