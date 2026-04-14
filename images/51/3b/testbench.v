`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire fc1;
    wire fc2;
    wire fc3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .fc1(fc1),
        .fc2(fc2),
        .fc3(fc3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equal values (Middle range)", test_num);
        a = 4'd8; b = 4'd8;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equal values (Minimum)", test_num);
        a = 4'd0; b = 4'd0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equal values (Maximum)", test_num);
        a = 4'd15; b = 4'd15;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a > b (General)", test_num);
        a = 4'd10; b = 4'd5;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a > b (Boundary)", test_num);
        a = 4'd15; b = 4'd0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a < b (General)", test_num);
        a = 4'd2; b = 4'd12;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a < b (Boundary)", test_num);
        a = 4'd0; b = 4'd15;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit difference (a < b)", test_num);
        a = 4'd7; b = 4'd8;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit difference (a > b)", test_num);
        a = 4'd8; b = 4'd7;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_fc1;
        input expected_fc2;
        input expected_fc3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fc1 === (expected_fc1 ^ fc1 ^ expected_fc1) &&
                expected_fc2 === (expected_fc2 ^ fc2 ^ expected_fc2) &&
                expected_fc3 === (expected_fc3 ^ fc3 ^ expected_fc3)) begin
                $display("PASS");
                $display("  Outputs: fc1=%b, fc2=%b, fc3=%b",
                         fc1, fc2, fc3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fc1=%b, fc2=%b, fc3=%b",
                         expected_fc1, expected_fc2, expected_fc3);
                $display("  Got:      fc1=%b, fc2=%b, fc3=%b",
                         fc1, fc2, fc3);
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
