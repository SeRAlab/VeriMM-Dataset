`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [49:0] in;
    wire majority_out;
    wire out_and;
    wire out_or;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .majority_out(majority_out),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 50'd0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            in = 50'h0;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();
            in = {50{1'b1}};
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Set", test_num);
            reset_dut();
            in = 50'h1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exactly 25 Bits Set (No Majority)", test_num);
            reset_dut();

            in = 50'h0000001FFFFFF;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exactly 26 Bits Set (Majority High)", test_num);
            reset_dut();

            in = 50'h0000003FFFFFF;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only MSB Set", test_num);
            reset_dut();
            in = (50'b1 << 49);
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (1010...)", test_num);
            reset_dut();
            in = 50'h2AAAAAAAAAAAA;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 49 Bits Set", test_num);
            reset_dut();
            in = 50'h3FFFFFFFFFFFF ^ 50'h1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
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
        input expected_majority_out;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        begin
            if (expected_majority_out === (expected_majority_out ^ majority_out ^ expected_majority_out) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         expected_majority_out, expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
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
        $dumpvars(0,clk, in, majority_out, out_and, out_or, out_xor);
    end

endmodule
