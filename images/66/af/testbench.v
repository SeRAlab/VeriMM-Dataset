`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire equal;
    wire greater_than;
    wire less_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .equal(equal),
        .greater_than(greater_than),
        .less_than(less_than)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: A=0, B=0 (Equality check)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: A=15, B=15 (Max value equality)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: A=15, B=0 (Max vs Min Greater check)", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: A=0, B=15 (Min vs Max Less check)", test_num);
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: A=8, B=7 (MSB transition check - Greater)", test_num);
            A = 4'b1000;
            B = 4'b0111;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: A=7, B=8 (MSB transition check - Less)", test_num);
            A = 4'b0111;
            B = 4'b1000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: A=10, B=5 (Arbitrary values check)", test_num);
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: A=3, B=9 (Arbitrary values check)", test_num);
            A = 4'd3;
            B = 4'd9;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: A=1, B=0 (LSB difference - Greater)", test_num);
            A = 4'b0001;
            B = 4'b0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: A=14, B=15 (LSB difference - Less)", test_num);
            A = 4'b1110;
            B = 4'b1111;
            #1;

            check_outputs(0, 0, 1);
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
        input expected_equal;
        input expected_greater_than;
        input expected_less_than;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_less_than === (expected_less_than ^ less_than ^ expected_less_than)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater_than=%b, less_than=%b",
                         expected_equal, expected_greater_than, expected_less_than);
                $display("  Got:      equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
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
