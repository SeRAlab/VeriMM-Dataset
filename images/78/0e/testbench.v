`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [7:0] twos_complement;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .twos_complement(twos_complement)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Zero (4'b0000)", test_num);
        binary = 4'b0000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Minimum Positive (4'b0001)", test_num);
        binary = 4'b0001;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Maximum Positive (4'b0111)", test_num);
        binary = 4'b0111;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Most Negative (4'b1000)", test_num);
        binary = 4'b1000;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Slightly Negative (4'b1111)", test_num);
        binary = 4'b1111;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Negative (4'b1001)", test_num);
        binary = 4'b1001;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Negative (4'b1100)", test_num);
        binary = 4'b1100;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Positive (4'b0100)", test_num);
        binary = 4'b0100;
        #1;

        check_outputs(8'h04);
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
        input [7:0] expected_twos_complement;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_twos_complement === (expected_twos_complement ^ twos_complement ^ expected_twos_complement)) begin
                $display("PASS");
                $display("  Outputs: twos_complement=%h",
                         twos_complement);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: twos_complement=%h",
                         expected_twos_complement);
                $display("  Got:      twos_complement=%h",
                         twos_complement);
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
