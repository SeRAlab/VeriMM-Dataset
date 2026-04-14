`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] V;
    wire [3:0] A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .V(V),
        .A(A)
    );
    task testcase000;

        begin
            test_num = 0;
            V = 4'b0000;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            V = 4'b0001;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            V = 4'b0010;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            V = 4'b0011;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            V = 4'b0100;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            V = 4'b0101;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            V = 4'b0110;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            V = 4'b0111;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            V = 4'b1000;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            V = 4'b1001;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            V = 4'b1010;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            V = 4'b1011;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            V = 4'b1100;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            V = 4'b1101;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            V = 4'b1110;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            V = 4'b1111;
            expected_val = get_expected(V);
            $display("Test Case %0d: V=%b", test_num, V);
            #1;

            check_outputs(expected_val);
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


        testcase000();
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
        input [3:0] expected_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%h",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h",
                         expected_A);
                $display("  Got:      A=%h",
                         A);
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
