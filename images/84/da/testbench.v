`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inp;
    wire [31:0] shifted_inp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .shifted_inp(shifted_inp)
    );
    task testcase001;

        begin
            test_num = 1;
            inp = 32'h00000000;
            $display("Test Case %0d: All Zeros (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            inp = 32'hFFFFFFFF;
            $display("Test Case %0d: All Ones (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            inp = 32'h00000001;
            $display("Test Case %0d: LSB Shift (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            inp = 32'hC0000000;
            $display("Test Case %0d: Overflow Shift (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            inp = 32'hAAAAAAAA;
            $display("Test Case %0d: Pattern A (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'hAAAAAAA8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            inp = 32'h55555555;
            $display("Test Case %0d: Pattern 5 (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'h55555554);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            inp = 32'h12345678;
            $display("Test Case %0d: Random Pattern (inp=%h)", test_num, inp);
            #1;

            check_outputs(32'h48D159E0);
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
        input [31:0] expected_shifted_inp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_inp === (expected_shifted_inp ^ shifted_inp ^ expected_shifted_inp)) begin
                $display("PASS");
                $display("  Outputs: shifted_inp=%h",
                         shifted_inp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_inp=%h",
                         expected_shifted_inp);
                $display("  Got:      shifted_inp=%h",
                         shifted_inp);
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
