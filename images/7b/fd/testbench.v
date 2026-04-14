`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] input_a;
    reg [3:0] input_b;
    reg input_c;
    reg input_d;
    reg input_e;
    wire [3:0] output_a;
    wire [3:0] output_b;
    wire output_c;
    wire output_d;
    wire output_e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
        .input_c(input_c),
        .input_d(input_d),
        .input_e(input_e),
        .output_a(output_a),
        .output_b(output_b),
        .output_c(output_c),
        .output_d(output_d),
        .output_e(output_e)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            input_a = 0; input_b = 0; input_c = 0; input_d = 0; input_e = 0;
            @(posedge clk);


            input_a = 4'd5; input_b = 4'd3;
            input_c = 1'b0; input_d = 1'b0; input_e = 1'b0;

            @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            input_a = 0; input_b = 0; input_c = 0; input_d = 0; input_e = 0;
            @(posedge clk);


            input_a = 4'd4; input_b = 4'd10;
            input_c = 1'b1; input_d = 1'b1; input_e = 1'b0;

            @(posedge clk);

            #1;


            check_outputs(4'b1010, 4'd14, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            input_a = 0; input_b = 0; input_c = 0; input_d = 0; input_e = 0;
            @(posedge clk);


            input_a = 4'd7; input_b = 4'd7;
            input_c = 1'b0; input_d = 1'b1; input_e = 1'b0;

            @(posedge clk);

            #1;


            check_outputs(4'd14, 4'd7, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            input_a = 0; input_b = 0; input_c = 0; input_d = 0; input_e = 0;
            @(posedge clk);


            input_a = 4'd2; input_b = 4'd2;
            input_c = 1'b1; input_d = 1'b0; input_e = 1'b1;

            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd2, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            input_a = 0; input_b = 0; input_c = 0; input_d = 0; input_e = 0;
            @(posedge clk);


            input_a = 4'd15; input_b = 4'd1;
            input_c = 1'b0; input_d = 1'b0; input_e = 1'b0;

            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd1, 1'b1, 1'b0, 1'b1);
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
        input [3:0] expected_output_a;
        input [3:0] expected_output_b;
        input expected_output_c;
        input expected_output_d;
        input expected_output_e;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_a === (expected_output_a ^ output_a ^ expected_output_a) &&
                expected_output_b === (expected_output_b ^ output_b ^ expected_output_b) &&
                expected_output_c === (expected_output_c ^ output_c ^ expected_output_c) &&
                expected_output_d === (expected_output_d ^ output_d ^ expected_output_d) &&
                expected_output_e === (expected_output_e ^ output_e ^ expected_output_e)) begin
                $display("PASS");
                $display("  Outputs: output_a=%h, output_b=%h, output_c=%b, output_d=%b, output_e=%b",
                         output_a, output_b, output_c, output_d, output_e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_a=%h, output_b=%h, output_c=%b, output_d=%b, output_e=%b",
                         expected_output_a, expected_output_b, expected_output_c, expected_output_d, expected_output_e);
                $display("  Got:      output_a=%h, output_b=%h, output_c=%b, output_d=%b, output_e=%b",
                         output_a, output_b, output_c, output_d, output_e);
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
