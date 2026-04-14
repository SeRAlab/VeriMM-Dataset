`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg reset_L;
    reg selector;
    reg valid_bit0;
    reg valid_bit1;
    wire [3:0] data_out;
    wire valid_bit_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .reset_L(reset_L),
        .selector(selector),
        .valid_bit0(valid_bit0),
        .valid_bit1(valid_bit1),
        .data_out(data_out),
        .valid_bit_out(valid_bit_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Active-low Reset", test_num);
            reset_L = 0;
            selector = 0;
            in0 = 4'hA;
            in1 = 4'hB;
            valid_bit0 = 1;
            valid_bit1 = 1;
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Selector 0, Input 0 Valid", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 0;
            in0 = 4'h5;
            in1 = 4'hE;
            valid_bit0 = 1;
            valid_bit1 = 0;
            #1;

            check_outputs(4'h5, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Selector 0, Input 0 Invalid", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 0;
            in0 = 4'h5;
            in1 = 4'hE;
            valid_bit0 = 0;
            valid_bit1 = 1;
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Selector 1, Input 1 Valid", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 1;
            in0 = 4'h3;
            in1 = 4'hC;
            valid_bit0 = 0;
            valid_bit1 = 1;
            #1;

            check_outputs(4'hC, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Selector 1, Input 1 Invalid", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 1;
            in0 = 4'h3;
            in1 = 4'hC;
            valid_bit0 = 1;
            valid_bit1 = 0;
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset during active selection", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 1;
            in1 = 4'hF;
            valid_bit1 = 1;
            #5;
            reset_L = 0;
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Switching selector from 0 to 1", test_num);
            reset_L = 0; #5; reset_L = 1;
            in0 = 4'h1;
            in1 = 4'h2;
            valid_bit0 = 1;
            valid_bit1 = 1;
            selector = 0; #5;
            selector = 1;
            #1;

            check_outputs(4'h2, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Both valid, Select 0", test_num);
            reset_L = 0; #5; reset_L = 1;
            selector = 0;
            in0 = 4'h7;
            in1 = 4'hD;
            valid_bit0 = 1;
            valid_bit1 = 1;
            #1;

            check_outputs(4'h7, 1);
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
        input [3:0] expected_data_out;
        input expected_valid_bit_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_bit_out === (expected_valid_bit_out ^ valid_bit_out ^ expected_valid_bit_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_bit_out=%b",
                         data_out, valid_bit_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_bit_out=%b",
                         expected_data_out, expected_valid_bit_out);
                $display("  Got:      data_out=%h, valid_bit_out=%b",
                         data_out, valid_bit_out);
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
