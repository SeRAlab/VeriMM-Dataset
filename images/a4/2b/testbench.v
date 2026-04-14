`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inNum;
    wire outdt0;
    wire outdt1;
    wire outdt2;
    wire outdt3;
    wire outdt4;
    wire outdt5;
    wire outdt6;
    wire outdt7;
    wire outdt8;
    wire outdt9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inNum(inNum),
        .outdt0(outdt0),
        .outdt1(outdt1),
        .outdt2(outdt2),
        .outdt3(outdt3),
        .outdt4(outdt4),
        .outdt5(outdt5),
        .outdt6(outdt6),
        .outdt7(outdt7),
        .outdt8(outdt8),
        .outdt9(outdt9)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros");
        inNum = 32'h00000000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All target bits set to 1");
        inNum = 32'h000003FF;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: High bits set, target bits clear");
        inNum = 32'hFFFFFC00;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Alternating bits (Pattern 1010101010)");


        inNum = 32'h000002AA;
        #1;

        check_outputs(0, 1, 0, 1, 0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Alternating bits (Pattern 0101010101)");


        inNum = 32'h00000155;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Random complex pattern");




        inNum = 32'h12345678;
        #1;

        check_outputs(0, 0, 0, 1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Single bit walking (Bit 5 set)");
        inNum = 32'h00000020;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Boundary bit check (Bit 9 set)");
        inNum = 32'h00000200;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
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
        input expected_outdt0;
        input expected_outdt1;
        input expected_outdt2;
        input expected_outdt3;
        input expected_outdt4;
        input expected_outdt5;
        input expected_outdt6;
        input expected_outdt7;
        input expected_outdt8;
        input expected_outdt9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outdt0 === (expected_outdt0 ^ outdt0 ^ expected_outdt0) &&
                expected_outdt1 === (expected_outdt1 ^ outdt1 ^ expected_outdt1) &&
                expected_outdt2 === (expected_outdt2 ^ outdt2 ^ expected_outdt2) &&
                expected_outdt3 === (expected_outdt3 ^ outdt3 ^ expected_outdt3) &&
                expected_outdt4 === (expected_outdt4 ^ outdt4 ^ expected_outdt4) &&
                expected_outdt5 === (expected_outdt5 ^ outdt5 ^ expected_outdt5) &&
                expected_outdt6 === (expected_outdt6 ^ outdt6 ^ expected_outdt6) &&
                expected_outdt7 === (expected_outdt7 ^ outdt7 ^ expected_outdt7) &&
                expected_outdt8 === (expected_outdt8 ^ outdt8 ^ expected_outdt8) &&
                expected_outdt9 === (expected_outdt9 ^ outdt9 ^ expected_outdt9)) begin
                $display("PASS");
                $display("  Outputs: outdt0=%b, outdt1=%b, outdt2=%b, outdt3=%b, outdt4=%b, outdt5=%b, outdt6=%b, outdt7=%b, outdt8=%b, outdt9=%b",
                         outdt0, outdt1, outdt2, outdt3, outdt4, outdt5, outdt6, outdt7, outdt8, outdt9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outdt0=%b, outdt1=%b, outdt2=%b, outdt3=%b, outdt4=%b, outdt5=%b, outdt6=%b, outdt7=%b, outdt8=%b, outdt9=%b",
                         expected_outdt0, expected_outdt1, expected_outdt2, expected_outdt3, expected_outdt4, expected_outdt5, expected_outdt6, expected_outdt7, expected_outdt8, expected_outdt9);
                $display("  Got:      outdt0=%b, outdt1=%b, outdt2=%b, outdt3=%b, outdt4=%b, outdt5=%b, outdt6=%b, outdt7=%b, outdt8=%b, outdt9=%b",
                         outdt0, outdt1, outdt2, outdt3, outdt4, outdt5, outdt6, outdt7, outdt8, outdt9);
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
