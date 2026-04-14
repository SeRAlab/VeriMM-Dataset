`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in;
    wire out_majority;
    wire out_shifted;
    wire out_zero_pairs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_majority(out_majority),
        .out_shifted(out_shifted),
        .out_zero_pairs(out_zero_pairs)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (7'b0000000)", test_num);
            in = 7'b0000000;



            #1;




            check_outputs(0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (7'b1111111)", test_num);
            in = 7'b1111111;



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority 1, No Zero Pairs (7'b1010101)", test_num);
            in = 7'b1010101;



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Majority 0, No Zero Pairs (7'b0101010)", test_num);
            in = 7'b0101010;



            #1;




            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero pair at start (7'b0011111)", test_num);
            in = 7'b0011111;



            #1;




            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero pair at end (7'b1111100)", test_num);
            in = 7'b1111100;



            #1;




            check_outputs(1, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero pair in middle (7'b1100111)", test_num);
            in = 7'b1100111;



            #1;




            check_outputs(1, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Almost Shifted check (7'b1111110)", test_num);
            in = 7'b1111110;



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: One zero (7'b1110111)", test_num);
            in = 7'b1110111;



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge Case Majority (7'b1111000)", test_num);
            in = 7'b1111000;



            #1;




            check_outputs(1, 0, 1);
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
        input expected_out_majority;
        input expected_out_shifted;
        input expected_out_zero_pairs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_majority === (expected_out_majority ^ out_majority ^ expected_out_majority) &&
                expected_out_shifted === (expected_out_shifted ^ out_shifted ^ expected_out_shifted) &&
                expected_out_zero_pairs === (expected_out_zero_pairs ^ out_zero_pairs ^ expected_out_zero_pairs)) begin
                $display("PASS");
                $display("  Outputs: out_majority=%b, out_shifted=%b, out_zero_pairs=%b",
                         out_majority, out_shifted, out_zero_pairs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_majority=%b, out_shifted=%b, out_zero_pairs=%b",
                         expected_out_majority, expected_out_shifted, expected_out_zero_pairs);
                $display("  Got:      out_majority=%b, out_shifted=%b, out_zero_pairs=%b",
                         out_majority, out_shifted, out_zero_pairs);
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
