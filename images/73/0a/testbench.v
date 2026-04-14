`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] s;
    wire [6:0] seg7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .seg7(seg7)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 2'b00;
            $display("Test Case %0d: s = %b (Digit 0)", test_num, s);
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 2'b01;
            $display("Test Case %0d: s = %b (Digit 1)", test_num, s);
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 2'b10;
            $display("Test Case %0d: s = %b (Digit 2)", test_num, s);
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 2'b11;
            $display("Test Case %0d: s = %b (Digit 3)", test_num, s);
            #1;

            check_outputs(7'b1001111);
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
        input [6:0] expected_seg7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg7 === (expected_seg7 ^ seg7 ^ expected_seg7)) begin
                $display("PASS");
                $display("  Outputs: seg7=%h",
                         seg7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg7=%h",
                         expected_seg7);
                $display("  Got:      seg7=%h",
                         seg7);
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
