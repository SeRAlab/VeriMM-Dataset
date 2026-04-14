`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ShiftVal;
    wire [14:0] LSRes;
    wire [7:0] RSRes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ShiftVal(ShiftVal),
        .LSRes(LSRes),
        .RSRes(RSRes)
    );
    task testcase001;

        begin
            test_num = 1;
            ShiftVal = 4'd0;
            #1;

            check_outputs(15'h7FC9, 8'hC9);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ShiftVal = 4'd1;
            #1;

            check_outputs(15'h7F92, 8'hE4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ShiftVal = 4'd2;
            #1;

            check_outputs(15'h7F24, 8'hF2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ShiftVal = 4'd4;
            #1;

            check_outputs(15'h7C90, 8'hFC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ShiftVal = 4'd6;
            #1;

            check_outputs(15'h7240, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ShiftVal = 4'd8;
            #1;

            check_outputs(15'h4900, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ShiftVal = 4'd10;
            #1;

            check_outputs(15'h2400, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ShiftVal = 4'd15;
            #1;

            check_outputs(15'h0000, 8'hFF);
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
        input [14:0] expected_LSRes;
        input [7:0] expected_RSRes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LSRes === (expected_LSRes ^ LSRes ^ expected_LSRes) &&
                expected_RSRes === (expected_RSRes ^ RSRes ^ expected_RSRes)) begin
                $display("PASS");
                $display("  Outputs: LSRes=%h, RSRes=%h",
                         LSRes, RSRes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LSRes=%h, RSRes=%h",
                         expected_LSRes, expected_RSRes);
                $display("  Got:      LSRes=%h, RSRes=%h",
                         LSRes, RSRes);
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
