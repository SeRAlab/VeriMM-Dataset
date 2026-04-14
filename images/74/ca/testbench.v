`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [31:0] in;
    wire [31:0] out_and;
    wire [31:0] out_final;
    wire [31:0] out_xor;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .out_and(out_and),
        .out_final(out_final),
        .out_xor(out_xor),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            d = 0; in = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            d = 1; in = 32'h00FF00FF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h000000FF, 32'h000000FF, 32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            d = 1; in = 32'hFF0000FF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 32'h0000FFFF, 32'h0000FFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 0; in = 32'h12345678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00001230, 32'h0000567C, 32'h0000444C, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            d = 1; in = 32'h80000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 32'h00008001, 32'h00008000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            d = 1; in = 32'h0;
            #2;

            if (q === 0) begin
                $display("TC006 Part A PASS: q remains 0 before clock");
            end

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h1, 32'h0, 1'b1);
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
        input [31:0] expected_out_and;
        input [31:0] expected_out_final;
        input [31:0] expected_out_xor;
        input expected_q;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_final === (expected_out_final ^ out_final ^ expected_out_final) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_final=%h, out_xor=%h, q=%b",
                         out_and, out_final, out_xor, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_final=%h, out_xor=%h, q=%b",
                         expected_out_and, expected_out_final, expected_out_xor, expected_q);
                $display("  Got:      out_and=%h, out_final=%h, out_xor=%h, q=%b",
                         out_and, out_final, out_xor, q);
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
        $dumpvars(0,clk, d, in, out_and, out_final, out_xor, q);
    end

endmodule
