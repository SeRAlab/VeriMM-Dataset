`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data1;
    reg [63:0] data2;
    reg [1:0] operation;
    wire NaN_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .operation(operation),
        .NaN_flag(NaN_flag)
    );
    task testcase001;

        begin
            test_num = 1;
            operation = 2'b00;
            data1 = 64'h3FF0000000000000;
            data2 = 64'h4000000000000000;
            $display("Test Case %0d: Normal numbers", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            operation = 2'b00;
            data1 = 64'h7FF8000000000000;
            data2 = 64'h3FF0000000000000;
            $display("Test Case %0d: data1 is NaN", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            operation = 2'b01;
            data1 = 64'h3FF0000000000000;
            data2 = 64'hFFF0000000000001;
            $display("Test Case %0d: data2 is NaN", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            operation = 2'b10;
            data1 = 64'h7FFFFFFFFFFFFFFF;
            data2 = 64'hFFF123456789ABCD;
            $display("Test Case %0d: Both inputs are NaN", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            operation = 2'b00;
            data1 = 64'h7FF0000000000000;
            data2 = 64'h0000000000000000;
            $display("Test Case %0d: Infinity check (should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            operation = 2'b11;
            data1 = 64'h4000000000000000;
            data2 = 64'hFFF0000000000000;
            $display("Test Case %0d: Negative Infinity check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            operation = 2'b00;
            data1 = 64'h0000000000000000;
            data2 = 64'h8000000000000000;
            $display("Test Case %0d: Zeroes check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            operation = 2'b00;
            data1 = 64'h7FEFFFFFFFFFFFFF;
            data2 = 64'h0000000000000001;
            $display("Test Case %0d: Extremes (finite)", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_NaN_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NaN_flag === (expected_NaN_flag ^ NaN_flag ^ expected_NaN_flag)) begin
                $display("PASS");
                $display("  Outputs: NaN_flag=%b",
                         NaN_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NaN_flag=%b",
                         expected_NaN_flag);
                $display("  Got:      NaN_flag=%b",
                         NaN_flag);
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
