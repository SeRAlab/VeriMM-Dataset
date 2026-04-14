`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire split_data_0;
    wire split_data_1;
    wire split_data_2;
    wire split_data_3;
    wire split_data_4;
    wire split_data_5;
    wire split_data_6;
    wire split_data_7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .split_data_0(split_data_0),
        .split_data_1(split_data_1),
        .split_data_2(split_data_2),
        .split_data_3(split_data_3),
        .split_data_4(split_data_4),
        .split_data_5(split_data_5),
        .split_data_6(split_data_6),
        .split_data_7(split_data_7)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data = 8'b00000000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        data = 8'b11111111;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits (01010101 pattern)", test_num);

        data = 8'h55;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits (10101010 pattern)", test_num);

        data = 8'hAA;
        #1;

        check_outputs(0, 1, 0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking One (Low Nibble)", test_num);
        data = 8'b00000001;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking One (High Nibble)", test_num);
        data = 8'b10000000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle Bits Pattern", test_num);
        data = 8'b00111100;
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Pattern", test_num);
        data = 8'b10010010;
        #1;

        check_outputs(0, 1, 0, 0, 1, 0, 0, 1);
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
        input expected_split_data_0;
        input expected_split_data_1;
        input expected_split_data_2;
        input expected_split_data_3;
        input expected_split_data_4;
        input expected_split_data_5;
        input expected_split_data_6;
        input expected_split_data_7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_split_data_0 === (expected_split_data_0 ^ split_data_0 ^ expected_split_data_0) &&
                expected_split_data_1 === (expected_split_data_1 ^ split_data_1 ^ expected_split_data_1) &&
                expected_split_data_2 === (expected_split_data_2 ^ split_data_2 ^ expected_split_data_2) &&
                expected_split_data_3 === (expected_split_data_3 ^ split_data_3 ^ expected_split_data_3) &&
                expected_split_data_4 === (expected_split_data_4 ^ split_data_4 ^ expected_split_data_4) &&
                expected_split_data_5 === (expected_split_data_5 ^ split_data_5 ^ expected_split_data_5) &&
                expected_split_data_6 === (expected_split_data_6 ^ split_data_6 ^ expected_split_data_6) &&
                expected_split_data_7 === (expected_split_data_7 ^ split_data_7 ^ expected_split_data_7)) begin
                $display("PASS");
                $display("  Outputs: split_data_0=%b, split_data_1=%b, split_data_2=%b, split_data_3=%b, split_data_4=%b, split_data_5=%b, split_data_6=%b, split_data_7=%b",
                         split_data_0, split_data_1, split_data_2, split_data_3, split_data_4, split_data_5, split_data_6, split_data_7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: split_data_0=%b, split_data_1=%b, split_data_2=%b, split_data_3=%b, split_data_4=%b, split_data_5=%b, split_data_6=%b, split_data_7=%b",
                         expected_split_data_0, expected_split_data_1, expected_split_data_2, expected_split_data_3, expected_split_data_4, expected_split_data_5, expected_split_data_6, expected_split_data_7);
                $display("  Got:      split_data_0=%b, split_data_1=%b, split_data_2=%b, split_data_3=%b, split_data_4=%b, split_data_5=%b, split_data_6=%b, split_data_7=%b",
                         split_data_0, split_data_1, split_data_2, split_data_3, split_data_4, split_data_5, split_data_6, split_data_7);
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
