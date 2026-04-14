`timescale 1ns/1ps

module digital_lock_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] code_input;
    reg [3:0] correct_code;
    wire unlock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_lock dut (
        .code_input(code_input),
        .correct_code(correct_code),
        .unlock(unlock)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Correct code match (all zeros)");
            correct_code = 4'b0000;
            code_input = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Incorrect code (all ones input for zero reference)");
            correct_code = 4'b0000;
            code_input = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Correct code match (arbitrary pattern)");
            correct_code = 4'b1010;
            code_input = 4'b1010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Partial mismatch (single bit difference)");
            correct_code = 4'b1010;
            code_input = 4'b1011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Correct code match (all ones)");
            correct_code = 4'b1111;
            code_input = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Input is bitwise inversion of correct code");
            correct_code = 4'b0101;
            code_input = 4'b1010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Change reference code and verify unlock update");
            correct_code = 4'b1100;
            code_input = 4'b1100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Verify unlock remains low for incorrect input on new reference");
            correct_code = 4'b1100;
            code_input = 4'b0011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_lock Testbench");
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
        input expected_unlock;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_unlock === (expected_unlock ^ unlock ^ expected_unlock)) begin
                $display("PASS");
                $display("  Outputs: unlock=%b",
                         unlock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: unlock=%b",
                         expected_unlock);
                $display("  Got:      unlock=%b",
                         unlock);
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
