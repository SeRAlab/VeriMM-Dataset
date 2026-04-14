`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire [7:0] sum_and;
    wire [7:0] sum_or;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .sum_and(sum_and),
        .sum_or(sum_or)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 8'hFF;


            #1;



            check_outputs(8'hFE, 8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 01010101", test_num);
            a = 8'h55;


            #1;



            check_outputs(8'h00, 8'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 10101010", test_num);
            a = 8'hAA;


            #1;



            check_outputs(8'h00, 8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower nibble 1s", test_num);
            a = 8'h0F;


            #1;



            check_outputs(8'h0E, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper nibble 1s", test_num);
            a = 8'hF0;


            #1;



            check_outputs(8'hE0, 8'h70);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit high (LSB)", test_num);
            a = 8'h01;


            #1;



            check_outputs(8'h00, 8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit high (MSB)", test_num);
            a = 8'h80;


            #1;



            check_outputs(8'h00, 8'h40);
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
        input [7:0] expected_sum_and;
        input [7:0] expected_sum_or;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum_and === (expected_sum_and ^ sum_and ^ expected_sum_and) &&
                expected_sum_or === (expected_sum_or ^ sum_or ^ expected_sum_or)) begin
                $display("PASS");
                $display("  Outputs: sum_and=%h, sum_or=%h",
                         sum_and, sum_or);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum_and=%h, sum_or=%h",
                         expected_sum_and, expected_sum_or);
                $display("  Got:      sum_and=%h, sum_or=%h",
                         sum_and, sum_or);
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
