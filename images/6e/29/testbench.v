`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_vector;
    wire [1:0] num_ones;
    wire [1:0] num_zeros;
    wire [3:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_vector(input_vector),
        .num_ones(num_ones),
        .num_zeros(num_zeros),
        .output_vector(output_vector)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros (4'b0000)", test_num);
        input_vector = 4'b0000;

        #1;


        check_outputs(2'd0, 2'd0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones (4'b1111)", test_num);
        input_vector = 4'b1111;

        #1;


        check_outputs(2'd0, 2'd0, 4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Single bit high (4'b0001)", test_num);
        input_vector = 4'b0001;

        #1;


        check_outputs(2'd1, 2'd3, 4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Three bits high (4'b0111)", test_num);
        input_vector = 4'b0111;

        #1;


        check_outputs(2'd3, 2'd1, 4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bits (4'b1010)", test_num);
        input_vector = 4'b1010;

        #1;


        check_outputs(2'd2, 2'd2, 4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: MSB high (4'b1000)", test_num);
        input_vector = 4'b1000;

        #1;


        check_outputs(2'd1, 2'd3, 4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Middle bits high (4'b0110)", test_num);
        input_vector = 4'b0110;

        #1;


        check_outputs(2'd2, 2'd2, 4'b0110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Single bit low (4'b1101)", test_num);
        input_vector = 4'b1101;

        #1;


        check_outputs(2'd3, 2'd1, 4'b1101);
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
        input [1:0] expected_num_ones;
        input [1:0] expected_num_zeros;
        input [3:0] expected_output_vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num_ones === (expected_num_ones ^ num_ones ^ expected_num_ones) &&
                expected_num_zeros === (expected_num_zeros ^ num_zeros ^ expected_num_zeros) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: num_ones=%h, num_zeros=%h, output_vector=%h",
                         num_ones, num_zeros, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_ones=%h, num_zeros=%h, output_vector=%h",
                         expected_num_ones, expected_num_zeros, expected_output_vector);
                $display("  Got:      num_ones=%h, num_zeros=%h, output_vector=%h",
                         num_ones, num_zeros, output_vector);
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
