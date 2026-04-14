`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_num;
    wire [3:0] bcd_num;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .bcd_num(bcd_num),
        .error(error)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input = 0", test_num);
        binary_num = 4'd0;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input = 5", test_num);
        binary_num = 4'd5;
        #1;

        check_outputs(4'h5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input = 9", test_num);
        binary_num = 4'd9;
        #1;

        check_outputs(4'h9, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input = 10 (Invalid)", test_num);
        binary_num = 4'd10;
        #1;

        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input = 12 (Invalid)", test_num);
        binary_num = 4'd12;
        #1;

        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input = 15 (Invalid)", test_num);
        binary_num = 4'd15;
        #1;

        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input = 3", test_num);
        binary_num = 4'd3;
        #1;

        check_outputs(4'h3, 1'b0);
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
        input [3:0] expected_bcd_num;
        input expected_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_num === (expected_bcd_num ^ bcd_num ^ expected_bcd_num) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: bcd_num=%h, error=%b",
                         bcd_num, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_num=%h, error=%b",
                         expected_bcd_num, expected_error);
                $display("  Got:      bcd_num=%h, error=%b",
                         bcd_num, error);
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
