`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bias;
    reg clk;
    reg [79:0] image;
    reg reset;
    reg [79:0] weight;
    wire [7:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bias(bias),
        .clk(clk),
        .image(image),
        .reset(reset),
        .weight(weight),
        .out(out),
        .valid(valid)
    );
    task wait_for_valid;

        begin
            while (!valid) @(posedge clk);
            @(negedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Zero Vectors", test_num);
            reset = 1;
            bias = 8'h05;
            weight = 80'h0;
            image = 80'h0;
            @(posedge clk);
            #1 reset = 0;
            wait_for_valid();
            #1;

            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Element Calculation", test_num);
            reset = 1;
            bias = 8'h0A;
            weight = {72'h0, 8'h02};
            image  = {72'h0, 8'h03};
            @(posedge clk);
            #1 reset = 0;
            wait_for_valid();
            #1;

            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Vector Uniform Values", test_num);
            reset = 1;
            bias = 8'h05;
            weight = {10{8'h02}};
            image  = {10{8'h04}};
            @(posedge clk);
            #1 reset = 0;
            wait_for_valid();
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Calculation with 8-bit Overflow/Wrapping", test_num);
            reset = 1;
            bias = 8'h00;
            weight = {10{8'h05}};
            image  = {10{8'h0A}};
            @(posedge clk);
            #1 reset = 0;
            wait_for_valid();
            #1;

            check_outputs(8'hF4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Heterogeneous Vector", test_num);
            reset = 1;
            bias = 8'h0A;
            weight = {56'h0, 8'h03, 8'h02, 8'h01};
            image  = {56'h0, 8'h01, 8'h02, 8'h01};
            @(posedge clk);
            #1 reset = 0;
            wait_for_valid();
            #1;

            check_outputs(8'h12, 1'b1);
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
        input [7:0] expected_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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

endmodule
