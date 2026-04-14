`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dataIn0;
    reg [7:0] dataIn1;
    wire [7:0] dataOut0;
    wire [7:0] dataOut1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataIn0(dataIn0),
        .dataIn1(dataIn1),
        .dataOut0(dataOut0),
        .dataOut1(dataOut1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: dataIn0 > dataIn1 (No swap expected)");
        dataIn0 = 8'd50;
        dataIn1 = 8'd20;
        #1;

        check_outputs(8'd50, 8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: dataIn1 > dataIn0 (Swap expected)");
        dataIn0 = 8'd15;
        dataIn1 = 8'd100;
        #1;

        check_outputs(8'd100, 8'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: dataIn0 == dataIn1");
        dataIn0 = 8'hAA;
        dataIn1 = 8'hAA;
        #1;

        check_outputs(8'hAA, 8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: dataIn0=0, dataIn1=255");
        dataIn0 = 8'h00;
        dataIn1 = 8'hFF;
        #1;

        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: dataIn0=255, dataIn1=0");
        dataIn0 = 8'hFF;
        dataIn1 = 8'h00;
        #1;

        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Close values (128, 127)");
        dataIn0 = 8'd127;
        dataIn1 = 8'd128;
        #1;

        check_outputs(8'd128, 8'd127);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Both values zero");
        dataIn0 = 8'd0;
        dataIn1 = 8'd0;
        #1;

        check_outputs(8'd0, 8'd0);
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
        input [7:0] expected_dataOut0;
        input [7:0] expected_dataOut1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataOut0 === (expected_dataOut0 ^ dataOut0 ^ expected_dataOut0) &&
                expected_dataOut1 === (expected_dataOut1 ^ dataOut1 ^ expected_dataOut1)) begin
                $display("PASS");
                $display("  Outputs: dataOut0=%h, dataOut1=%h",
                         dataOut0, dataOut1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut0=%h, dataOut1=%h",
                         expected_dataOut0, expected_dataOut1);
                $display("  Got:      dataOut0=%h, dataOut1=%h",
                         dataOut0, dataOut1);
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
