`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg alu_rst;
    reg [31:0] b;
    reg sys_clk;
    reg valid_i;
    wire [31:0] r;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alu_rst(alu_rst),
        .b(b),
        .sys_clk(sys_clk),
        .valid_i(valid_i),
        .r(r),
        .valid_o(valid_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            alu_rst = 1;
            a = 0;
            b = 0;
            valid_i = 0;
            @(posedge sys_clk);
            #1;
            alu_rst = 0;
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a > b (Standard)", test_num);
            reset_dut();
            a = 32'd1000;
            b = 32'd500;
            valid_i = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(32'h3f800000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a < b", test_num);
            reset_dut();
            a = 32'd250;
            b = 32'd500;
            valid_i = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a == b", test_num);
            reset_dut();
            a = 32'hABCDE000;
            b = 32'hABCDE000;
            valid_i = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: valid_i = 0 (Output invalid)", test_num);
            reset_dut();
            a = 32'd1000;
            b = 32'd500;
            valid_i = 1'b0;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(r, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Unsigned Comparison", test_num);
            reset_dut();
            a = 32'hFFFFFFFF;
            b = 32'h7FFFFFFF;
            valid_i = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(32'h3f800000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest values", test_num);
            reset_dut();
            a = 32'h00000001;
            b = 32'h00000000;
            valid_i = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(32'h3f800000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Validity Check", test_num);
            reset_dut();
            a = 32'd500;
            b = 32'd100;
            valid_i = 1'b1;
            alu_rst = 1'b1;
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(r, 1'b0);
            alu_rst = 1'b0;
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
        input [31:0] expected_r;
        input expected_valid_o;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: r=%h, valid_o=%b",
                         r, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h, valid_o=%b",
                         expected_r, expected_valid_o);
                $display("  Got:      r=%h, valid_o=%b",
                         r, valid_o);
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
        $dumpvars(0,a, alu_rst, b, sys_clk, valid_i, r, valid_o);
    end

endmodule
