`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] temp;
    wire TempGrave;
    wire TempLeve;
    wire TempNormal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .temp(temp),
        .TempGrave(TempGrave),
        .TempLeve(TempLeve),
        .TempNormal(TempNormal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: temp = 0 (Lower bound of Low)", test_num);
        temp = 4'd0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: temp = 3 (Mid Low)", test_num);
        temp = 4'd3;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: temp = 5 (Upper bound of Low)", test_num);
        temp = 4'd5;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: temp = 6 (Lower bound of Normal)", test_num);
        temp = 4'd6;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: temp = 8 (Mid Normal)", test_num);
        temp = 4'd8;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: temp = 10 (Upper bound of Normal)", test_num);
        temp = 4'd10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: temp = 11 (Lower bound of Grave)", test_num);
        temp = 4'd11;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: temp = 13 (Mid Grave)", test_num);
        temp = 4'd13;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: temp = 15 (Max Grave)", test_num);
        temp = 4'd15;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_TempGrave;
        input expected_TempLeve;
        input expected_TempNormal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_TempGrave === (expected_TempGrave ^ TempGrave ^ expected_TempGrave) &&
                expected_TempLeve === (expected_TempLeve ^ TempLeve ^ expected_TempLeve) &&
                expected_TempNormal === (expected_TempNormal ^ TempNormal ^ expected_TempNormal)) begin
                $display("PASS");
                $display("  Outputs: TempGrave=%b, TempLeve=%b, TempNormal=%b",
                         TempGrave, TempLeve, TempNormal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TempGrave=%b, TempLeve=%b, TempNormal=%b",
                         expected_TempGrave, expected_TempLeve, expected_TempNormal);
                $display("  Got:      TempGrave=%b, TempLeve=%b, TempNormal=%b",
                         TempGrave, TempLeve, TempNormal);
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
