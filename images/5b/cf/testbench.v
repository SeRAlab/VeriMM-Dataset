`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] s;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .r(r)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 4'b0000;
            $display("Test Case 001: s = 0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 4'b0001;
            $display("Test Case 002: s = 0001");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 4'b0010;
            $display("Test Case 003: s = 0010");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 4'b0011;
            $display("Test Case 004: s = 0011");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            s = 4'b0100;
            $display("Test Case 005: s = 0100");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            s = 4'b0101;
            $display("Test Case 006: s = 0101");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            s = 4'b0110;
            $display("Test Case 007: s = 0110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            s = 4'b0111;
            $display("Test Case 008: s = 0111");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            s = 4'b1000;
            $display("Test Case 009: s = 1000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            s = 4'b1001;
            $display("Test Case 010: s = 1001");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            s = 4'b1010;
            $display("Test Case 011: s = 1010");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            s = 4'b1011;
            $display("Test Case 012: s = 1011");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            s = 4'b1100;
            $display("Test Case 013: s = 1100");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            s = 4'b1101;
            $display("Test Case 014: s = 1101");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            s = 4'b1110;
            $display("Test Case 015: s = 1110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            s = 4'b1111;
            $display("Test Case 016: s = 1111");
            #1;

            check_outputs(1'b1);
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
        input expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%b",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b",
                         expected_r);
                $display("  Got:      r=%b",
                         r);
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
