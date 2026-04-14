`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    wire cout;
    wire [99:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 100'd0;
            b = 100'd0;
            cin = 0;
            $display("Test Case 001: 0 + 0 + 0");
            #1;

            check_outputs(1'b0, 100'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 100'd0;
            b = 100'd0;
            cin = 1;
            $display("Test Case 002: 0 + 0 + 1");
            #1;

            check_outputs(1'b0, 100'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 100'h123456789ABCDEF0123456789;
            b = 100'h1111111111111111111111111;
            cin = 0;
            $display("Test Case 003: Simple addition no carry-out");
            #1;

            check_outputs(1'b0, 100'h23456789BCDEF00123456789A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'd1;
            cin = 0;
            $display("Test Case 004: Boundary carry-out (Max + 1)");
            #1;

            check_outputs(1'b1, 100'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'd0;
            cin = 1;
            $display("Test Case 005: Max + 0 + cin=1 (Result 0 with cout=1)");
            #1;

            check_outputs(1'b1, 100'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            cin = 1;
            $display("Test Case 006: Max + Max + cin=1");


            #1;



            check_outputs(1'b1, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 100'h5555555555555555555555555;
            b = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            cin = 0;
            $display("Test Case 007: Alternating 0101 and 1010 patterns");
            #1;

            check_outputs(1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 100'h5555555555555555555555555;
            b = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            cin = 1;
            $display("Test Case 008: Alternating patterns + cin=1");
            #1;

            check_outputs(1'b1, 100'd0);
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
        input expected_cout;
        input [99:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
