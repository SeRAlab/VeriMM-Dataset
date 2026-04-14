`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg e;
    reg g;
    reg p;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .e(e),
        .g(g),
        .p(p),
        .z(z)
    );
    task testcase001;

        begin
            $display("Test Case 001: agpe = 0000");
            test_num = 1;
            a = 0; g = 0; p = 0; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: agpe = 0001");
            test_num = 2;
            a = 0; g = 0; p = 0; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: agpe = 0010");
            test_num = 3;
            a = 0; g = 0; p = 1; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: agpe = 0011");
            test_num = 4;
            a = 0; g = 0; p = 1; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: agpe = 0100");
            test_num = 5;
            a = 0; g = 1; p = 0; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: agpe = 0101");
            test_num = 6;
            a = 0; g = 1; p = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: agpe = 0110");
            test_num = 7;
            a = 0; g = 1; p = 1; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: agpe = 0111");
            test_num = 8;
            a = 0; g = 1; p = 1; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: agpe = 1000");
            test_num = 9;
            a = 1; g = 0; p = 0; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: agpe = 1001");
            test_num = 10;
            a = 1; g = 0; p = 0; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: agpe = 1010");
            test_num = 11;
            a = 1; g = 0; p = 1; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: agpe = 1011");
            test_num = 12;
            a = 1; g = 0; p = 1; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: agpe = 1100");
            test_num = 13;
            a = 1; g = 1; p = 0; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: agpe = 1101");
            test_num = 14;
            a = 1; g = 1; p = 0; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: agpe = 1110");
            test_num = 15;
            a = 1; g = 1; p = 1; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: agpe = 1111");
            test_num = 16;
            a = 1; g = 1; p = 1; e = 1;
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
