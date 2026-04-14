`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] in;
    wire [22:0] out_left;
    wire [22:0] out_right;
    wire [23:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_left(out_left),
        .out_right(out_right),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            in = 24'h000000;
            #1;

            check_outputs(23'h0, 23'h0, 24'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            in = 24'hFFFFFF;



            #1;




            check_outputs(23'h7FFFFF, 23'h7FFFFF, 24'h000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits AAAAAA", test_num);
            in = 24'hAAAAAA;



            #1;




            check_outputs(23'h000000, 23'h7FFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits 555555", test_num);
            in = 24'h555555;



            #1;




            check_outputs(23'h000000, 23'h7FFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LSB Only", test_num);
            in = 24'h000001;



            #1;




            check_outputs(23'h000000, 23'h000001, 24'h800001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB Only", test_num);
            in = 24'h800000;



            #1;




            check_outputs(23'h000000, 23'h400000, 24'hC00000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bottom Two Bits", test_num);
            in = 24'h000003;



            #1;




            check_outputs(23'h000001, 23'h000003, 24'h800002);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Top Two Bits", test_num);
            in = 24'hC00000;



            #1;




            check_outputs(23'h400000, 23'h600000, 24'hA00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walk Through Wrap", test_num);
            in = 24'h900009;





            #1;






            check_outputs(23'h000000, 23'h58000D, 24'h58000D);
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
        input [22:0] expected_out_left;
        input [22:0] expected_out_right;
        input [23:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_left === (expected_out_left ^ out_left ^ expected_out_left) &&
                expected_out_right === (expected_out_right ^ out_right ^ expected_out_right) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_left=%h, out_right=%h, out_xor=%h",
                         out_left, out_right, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_left=%h, out_right=%h, out_xor=%h",
                         expected_out_left, expected_out_right, expected_out_xor);
                $display("  Got:      out_left=%h, out_right=%h, out_xor=%h",
                         out_left, out_right, out_xor);
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
