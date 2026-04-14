`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire out_contiguous_ones;
    wire out_less_than_five;
    wire out_reverse_equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_contiguous_ones(out_contiguous_ones),
        .out_less_than_five(out_less_than_five),
        .out_reverse_equal(out_reverse_equal)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 10'b0000000000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 10'b1111111111;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 10'b0011110000;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 10'b1111001111;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 10'b1010101010;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 10'b0101010100;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 10'b1000110001;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 10'b1111000000;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 10'b0000001111;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 10'b1101101100;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 10'b0111001110;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 10'b0011111000;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in = 10'b1001111001;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        in = 10'b0001110000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        in = 10'b0110000110;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_out_contiguous_ones;
        input expected_out_less_than_five;
        input expected_out_reverse_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_contiguous_ones === (expected_out_contiguous_ones ^ out_contiguous_ones ^ expected_out_contiguous_ones) &&
                expected_out_less_than_five === (expected_out_less_than_five ^ out_less_than_five ^ expected_out_less_than_five) &&
                expected_out_reverse_equal === (expected_out_reverse_equal ^ out_reverse_equal ^ expected_out_reverse_equal)) begin
                $display("PASS");
                $display("  Outputs: out_contiguous_ones=%b, out_less_than_five=%b, out_reverse_equal=%b",
                         out_contiguous_ones, out_less_than_five, out_reverse_equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_contiguous_ones=%b, out_less_than_five=%b, out_reverse_equal=%b",
                         expected_out_contiguous_ones, expected_out_less_than_five, expected_out_reverse_equal);
                $display("  Got:      out_contiguous_ones=%b, out_less_than_five=%b, out_reverse_equal=%b",
                         out_contiguous_ones, out_less_than_five, out_reverse_equal);
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
