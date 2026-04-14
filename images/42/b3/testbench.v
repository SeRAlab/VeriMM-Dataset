`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [3:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .G(G)
    );
    task testcase001;

        begin
            $display("Test Case 001: Binary 0000");
            B = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Binary 0001");
            B = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Binary 0010");
            B = 4'b0010;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Binary 0011");
            B = 4'b0011;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Binary 0100");
            B = 4'b0100;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Binary 0111");
            B = 4'b0111;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Binary 1000");
            B = 4'b1000;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Binary 1010");
            B = 4'b1010;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Binary 1101");
            B = 4'b1101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Binary 1111");
            B = 4'b1111;
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%h",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%h",
                         expected_G);
                $display("  Got:      G=%h",
                         G);
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
