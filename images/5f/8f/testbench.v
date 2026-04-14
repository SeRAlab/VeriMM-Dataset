`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] in;
    wire out_all_zeros_excluding;
    wire out_any_five;
    wire out_palindromic;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_all_zeros_excluding(out_all_zeros_excluding),
        .out_any_five(out_any_five),
        .out_palindromic(out_palindromic)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 11'b00000100000;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 11'b00000000000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 11'b00000011111;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 11'b11111000000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 11'b00011111000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 11'b10101010101;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 11'b11111111111;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 11'b11111011111;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in = 11'b00000111100;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in = 11'b11010001011;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            in = 11'b00010100000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            in = 11'b10000100000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_out_all_zeros_excluding;
        input expected_out_any_five;
        input expected_out_palindromic;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_all_zeros_excluding === (expected_out_all_zeros_excluding ^ out_all_zeros_excluding ^ expected_out_all_zeros_excluding) &&
                expected_out_any_five === (expected_out_any_five ^ out_any_five ^ expected_out_any_five) &&
                expected_out_palindromic === (expected_out_palindromic ^ out_palindromic ^ expected_out_palindromic)) begin
                $display("PASS");
                $display("  Outputs: out_all_zeros_excluding=%b, out_any_five=%b, out_palindromic=%b",
                         out_all_zeros_excluding, out_any_five, out_palindromic);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_all_zeros_excluding=%b, out_any_five=%b, out_palindromic=%b",
                         expected_out_all_zeros_excluding, expected_out_any_five, expected_out_palindromic);
                $display("  Got:      out_all_zeros_excluding=%b, out_any_five=%b, out_palindromic=%b",
                         out_all_zeros_excluding, out_any_five, out_palindromic);
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
