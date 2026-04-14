`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] R1;
    reg [7:0] R2;
    wire [15:0] outand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R1(R1),
        .R2(R2),
        .outand(outand)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros", test_num);
        R1 = 8'h00;
        R2 = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All Ones", test_num);
        R1 = 8'hFF;
        R2 = 8'hFF;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Disjoint Bits (AA and 55)", test_num);
        R1 = 8'hAA;
        R2 = 8'h55;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Partial AND (F0 and 3C)", test_num);
        R1 = 8'hF0;
        R2 = 8'h3C;
        #1;

        check_outputs(16'h0030);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Identity AND (FF and A5)", test_num);
        R1 = 8'hFF;
        R2 = 8'hA5;
        #1;

        check_outputs(16'h00A5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: One Side Zero (00 and FF)", test_num);
        R1 = 8'h00;
        R2 = 8'hFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: High Nibble vs Low Nibble (F0 and 0F)", test_num);
        R1 = 8'hF0;
        R2 = 8'h0F;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Arbitrary Pattern (C3 and 99)", test_num);
        R1 = 8'hC3;
        R2 = 8'h99;
        #1;

        check_outputs(16'h0081);
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
        input [15:0] expected_outand;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outand === (expected_outand ^ outand ^ expected_outand)) begin
                $display("PASS");
                $display("  Outputs: outand=%h",
                         outand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outand=%h",
                         expected_outand);
                $display("  Got:      outand=%h",
                         outand);
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
