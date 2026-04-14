`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DataIn;
    wire [3:0] DataOut1;
    wire [3:0] DataOut2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataIn(DataIn),
        .DataOut1(DataOut1),
        .DataOut2(DataOut2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            DataIn = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones", test_num);
            DataIn = 4'b1111;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Alternating pattern 1010", test_num);
            DataIn = 4'b1010;
            #1;

            check_outputs(4'b1010, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Alternating pattern 0101", test_num);
            DataIn = 4'b0101;
            #1;

            check_outputs(4'b0101, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single bit high (MSB)", test_num);
            DataIn = 4'b1000;
            #1;

            check_outputs(4'b1000, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Single bit high (LSB)", test_num);
            DataIn = 4'b0001;
            #1;

            check_outputs(4'b0001, 4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random pattern 1100", test_num);
            DataIn = 4'b1100;
            #1;

            check_outputs(4'b1100, 4'b1100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random pattern 0011", test_num);
            DataIn = 4'b0011;
            #1;

            check_outputs(4'b0011, 4'b0011);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Pattern 0110", test_num);
            DataIn = 4'b0110;
            #1;

            check_outputs(4'b0110, 4'b0110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Pattern 1001", test_num);
            DataIn = 4'b1001;
            #1;

            check_outputs(4'b1001, 4'b1001);
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
        input [3:0] expected_DataOut1;
        input [3:0] expected_DataOut2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DataOut1 === (expected_DataOut1 ^ DataOut1 ^ expected_DataOut1) &&
                expected_DataOut2 === (expected_DataOut2 ^ DataOut2 ^ expected_DataOut2)) begin
                $display("PASS");
                $display("  Outputs: DataOut1=%h, DataOut2=%h",
                         DataOut1, DataOut2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut1=%h, DataOut2=%h",
                         expected_DataOut1, expected_DataOut2);
                $display("  Got:      DataOut1=%h, DataOut2=%h",
                         DataOut1, DataOut2);
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
