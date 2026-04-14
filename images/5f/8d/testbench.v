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
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            data = 8'b0000_0000;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Ones", test_num);
            data = 8'b1111_1111;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternating Bits (Pattern A)", test_num);

            data = 8'b1010_1010;


            #1;



            check_outputs(0, 1, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bits (Pattern B)", test_num);

            data = 8'b0101_0101;
            #1;

            check_outputs(1, 0, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Single Bit High (LSB)", test_num);
            data = 8'b0000_0001;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Single Bit High (MSB)", test_num);
            data = 8'b1000_0000;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Nibble Split (Lower High)", test_num);
            data = 8'b0000_1111;
            #1;

            check_outputs(1, 1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Nibble Split (Upper High)", test_num);
            data = 8'b1111_0000;
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Random Pattern 1", test_num);
            data = 8'b1100_1010;
            #1;

            check_outputs(0, 1, 0, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Random Pattern 2", test_num);
            data = 8'b0110_0110;
            #1;

            check_outputs(0, 1, 1, 0, 0, 1, 1, 0);
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
        testcase010();
        
        
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
