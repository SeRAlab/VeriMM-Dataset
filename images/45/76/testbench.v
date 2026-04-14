`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 4'b0000;
            #5;
            $display("Test Case 001: x=0000");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 4'b0001;
            #5;
            $display("Test Case 002: x=0001");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 4'b0010;
            #5;
            $display("Test Case 003: x=0010");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 4'b0011;
            #5;
            $display("Test Case 004: x=0011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 4'b0100;
            #5;
            $display("Test Case 005: x=0100");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 4'b0101;
            #5;
            $display("Test Case 006: x=0101");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 4'b0110;
            #5;
            $display("Test Case 007: x=0110");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 4'b0111;
            #5;
            $display("Test Case 008: x=0111");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x = 4'b1000;
            #5;
            $display("Test Case 009: x=1000");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x = 4'b1001;
            #5;
            $display("Test Case 010: x=1001");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            x = 4'b1010;
            #5;
            $display("Test Case 011: x=1010");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            x = 4'b1011;
            #5;
            $display("Test Case 012: x=1011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            x = 4'b1100;
            #5;
            $display("Test Case 013: x=1100");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            x = 4'b1101;
            #5;
            $display("Test Case 014: x=1101");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            x = 4'b1110;
            #5;
            $display("Test Case 015: x=1110");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            x = 4'b1111;
            #5;
            $display("Test Case 016: x=1111");
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
