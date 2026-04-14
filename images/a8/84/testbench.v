`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire [8:0] out_diff;
    wire [9:0] out_same;
    wire [8:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_diff(out_diff),
        .out_same(out_same),
        .out_sum(out_sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in = 10'b00_0000_0000;

            #1;


            check_outputs(9'h000, 10'h3FF, 9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in = 10'b11_1111_1111;

            #1;


            check_outputs(9'h1FF, 10'h3FF, 9'h1FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 1010", test_num);
            in = 10'b10_1010_1010;

            #1;


            check_outputs(9'h1FF, 10'h000, 9'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 0101", test_num);
            in = 10'b01_0101_0101;

            #1;


            check_outputs(9'h1FF, 10'h000, 9'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low bits high (000...011)", test_num);
            in = 10'b00_0000_0011;



            #1;




            check_outputs(9'h003, 10'h1FD, 9'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrapping check (100...001)", test_num);
            in = 10'b10_0000_0001;



            #1;




            check_outputs(9'h101, 10'h27E, 9'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Contiguous block", test_num);
            in = 10'b00_0111_0000;



            #1;




            check_outputs(9'h078, 10'h3B7, 9'h030);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scattered pairs (1100001100)", test_num);
            in = 10'b11_0000_1100;



            #1;




            check_outputs(9'h18E, 10'h175, 9'h104);
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
        input [8:0] expected_out_diff;
        input [9:0] expected_out_same;
        input [8:0] expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_diff === (expected_out_diff ^ out_diff ^ expected_out_diff) &&
                expected_out_same === (expected_out_same ^ out_same ^ expected_out_same) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_diff=%h, out_same=%h, out_sum=%h",
                         out_diff, out_same, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_diff=%h, out_same=%h, out_sum=%h",
                         expected_out_diff, expected_out_same, expected_out_sum);
                $display("  Got:      out_diff=%h, out_same=%h, out_sum=%h",
                         out_diff, out_same, out_sum);
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
