`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg rotate_right;
    reg shift_left;
    reg shift_right;
    wire [3:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rotate_right(rotate_right),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .shifted_data(shifted_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No control signals (Pass-through)", test_num);
            data = 4'b1010;
            shift_left = 0;
            shift_right = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (0101 -> 1010)", test_num);
            data = 4'b0101;
            shift_left = 1;
            shift_right = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (1001 -> 0010)", test_num);
            data = 4'b1001;
            shift_left = 1;
            shift_right = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right (1010 -> 0101)", test_num);
            data = 4'b1010;
            shift_left = 0;
            shift_right = 1;
            rotate_right = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right (0001 -> 0000)", test_num);
            data = 4'b0001;
            shift_left = 0;
            shift_right = 1;
            rotate_right = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right (0001 -> 1000)", test_num);
            data = 4'b0001;
            shift_left = 0;
            shift_right = 0;
            rotate_right = 1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right (1011 -> 1101)", test_num);
            data = 4'b1011;
            shift_left = 0;
            shift_right = 0;
            rotate_right = 1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pass-through with All Ones", test_num);
            data = 4'b1111;
            shift_left = 0;
            shift_right = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left All Ones (1111 -> 1110)", test_num);
            data = 4'b1111;
            shift_left = 1;
            shift_right = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right All Ones (1111 -> 0111)", test_num);
            data = 4'b1111;
            shift_left = 0;
            shift_right = 1;
            rotate_right = 0;
            #1;

            check_outputs(4'b0111);
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
        input [3:0] expected_shifted_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
