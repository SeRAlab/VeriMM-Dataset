`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] matrix_input;
    wire [1:0] output_col;
    wire [1:0] output_row;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .matrix_input(matrix_input),
        .output_col(output_col),
        .output_row(output_row)
    );
    task testcase001;

        begin
            $display("Test Case 001: Zero Matrix");
            test_num = 1;
            matrix_input = 4'b0000;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Element 'a' only");
            test_num = 2;
            matrix_input = 4'b1000;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Element 'b' only");
            test_num = 3;
            matrix_input = 4'b0100;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Element 'c' only");
            test_num = 4;
            matrix_input = 4'b0010;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Element 'd' only");
            test_num = 5;
            matrix_input = 4'b0001;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: First Row Full");
            test_num = 6;
            matrix_input = 4'b1100;
            #1;

            check_outputs(2'b10, 2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Second Row Full");
            test_num = 7;
            matrix_input = 4'b0011;
            #1;

            check_outputs(2'b01, 2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: First Column Full");
            test_num = 8;
            matrix_input = 4'b1010;
            #1;

            check_outputs(2'b11, 2'b10);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Second Column Full");
            test_num = 9;
            matrix_input = 4'b0101;
            #1;

            check_outputs(2'b11, 2'b01);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: All Ones Matrix");
            test_num = 10;
            matrix_input = 4'b1111;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [1:0] expected_output_col;
        input [1:0] expected_output_row;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_col === (expected_output_col ^ output_col ^ expected_output_col) &&
                expected_output_row === (expected_output_row ^ output_row ^ expected_output_row)) begin
                $display("PASS");
                $display("  Outputs: output_col=%h, output_row=%h",
                         output_col, output_row);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_col=%h, output_row=%h",
                         expected_output_col, expected_output_row);
                $display("  Got:      output_col=%h, output_row=%h",
                         output_col, output_row);
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
