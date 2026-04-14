`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] count;
    wire [7:0] nextCount;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .nextCount(nextCount)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Increment from zero", test_num);
        count = 8'h00;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Increment from a standard value", test_num);
        count = 8'h0A;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Increment at bit-flip boundary", test_num);
        count = 8'h7F;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Increment near maximum", test_num);
        count = 8'hFE;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Wraparound from 255 to 0", test_num);
        count = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Check alternating bit pattern", test_num);
        count = 8'hAA;
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Check another pattern", test_num);
        count = 8'h55;
        #1;

        check_outputs(8'h56);
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
        input [7:0] expected_nextCount;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nextCount === (expected_nextCount ^ nextCount ^ expected_nextCount)) begin
                $display("PASS");
                $display("  Outputs: nextCount=%h",
                         nextCount);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextCount=%h",
                         expected_nextCount);
                $display("  Got:      nextCount=%h",
                         nextCount);
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
