`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg [4:0] in;
    reg rst_n;
    wire final_output;
    wire out_and;
    wire out_nor;
    wire out_or;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .final_output(final_output),
        .out_and(out_and),
        .out_nor(out_nor),
        .out_or(out_or)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            in = 5'b0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high logic check", test_num);
            reset_dut();
            in = 5'b11111;
            a = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits low logic check", test_num);
            reset_dut();
            in = 5'b00000;
            a = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits logic check", test_num);
            reset_dut();
            in = 5'b10100;
            a = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rising edge with decoder match", test_num);
            reset_dut();
            in = 5'b00010;
            a = 0;
            @(posedge clk);
            #1 a = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Falling edge with decoder match", test_num);
            reset_dut();
            in = 5'b00011;
            a = 1;
            @(posedge clk);
            #1 a = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge detected, no decoder match", test_num);
            reset_dut();
            in = 5'b00001;
            a = 0;
            @(posedge clk);
            #1 a = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No edge, decoder match", test_num);
            reset_dut();
            in = 5'b00010;
            a = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            in = 5'b11111;
            a = 0;
            @(posedge clk);
            #1 rst_n = 0;
            @(posedge clk);
            #1;


            if (final_output !== 1'b0) begin
                $display("FAIL: final_output not reset");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: final_output reset");
                pass_count = pass_count + 1;
            end
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
        input expected_final_output;
        input expected_out_and;
        input expected_out_nor;
        input expected_out_or;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or)) begin
                $display("PASS");
                $display("  Outputs: final_output=%b, out_and=%b, out_nor=%b, out_or=%b",
                         final_output, out_and, out_nor, out_or);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%b, out_and=%b, out_nor=%b, out_or=%b",
                         expected_final_output, expected_out_and, expected_out_nor, expected_out_or);
                $display("  Got:      final_output=%b, out_and=%b, out_nor=%b, out_or=%b",
                         final_output, out_and, out_nor, out_or);
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
        $dumpvars(0,a, clk, in, rst_n, final_output, out_and, out_nor, out_or);
    end

endmodule
