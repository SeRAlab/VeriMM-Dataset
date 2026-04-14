`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .count(count)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            num = 16'h0000;
            $display("Testcase 001: All zeros (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            num = 16'h0001;
            $display("Testcase 002: Single bit LSB (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            num = 16'h8000;
            $display("Testcase 003: Single bit MSB (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            num = 16'h5555;
            $display("Testcase 004: Alternating bits (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            num = 16'h000F;
            $display("Testcase 005: Single nibble (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            num = 16'h7FFF;
            $display("Testcase 006: Fifteen bits set (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            num = 16'hFFFF;
            $display("Testcase 007: All sixteen bits set - expecting truncation to 4-bit (num = 16'h%0h)", num);

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            num = 16'hEBA9;
            $display("Testcase 008: Arbitrary pattern (num = 16'h%0h)", num);
            #1;

            check_outputs(4'd10);
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
        input [3:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
