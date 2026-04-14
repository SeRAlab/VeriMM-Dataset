`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] in;
    wire [12:0] out_and;
    wire [12:0] out_nor;
    wire [13:0] out_xor_wrap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_nor(out_nor),
        .out_xor_wrap(out_xor_wrap)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 14'h0000;
            #1;

            check_outputs(13'h0000, 13'h1FFF, 14'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 14'h3FFF;
            #1;

            check_outputs(13'h1FFF, 13'h0000, 14'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 14'h1555;



            #1;




            check_outputs(13'h0000, 13'h0000, 14'h3FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 14'h2AAA;
            #1;

            check_outputs(13'h0000, 13'h0000, 14'h3FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 14'h0001;



            #1;




            check_outputs(13'h0000, 13'h1FFE, 14'h0003);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 14'h2000;



            #1;




            check_outputs(13'h0000, 13'h0FFF, 14'h2001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 14'h1234;



            #1;




            check_outputs(13'h0010, 13'h04C1, 14'h1B2C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 14'h0F0F;



            #1;




            check_outputs(13'h0707, 13'h10F0, 14'h2111);
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
        input [12:0] expected_out_and;
        input [12:0] expected_out_nor;
        input [13:0] expected_out_xor_wrap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_xor_wrap === (expected_out_xor_wrap ^ out_xor_wrap ^ expected_out_xor_wrap)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_nor=%h, out_xor_wrap=%h",
                         out_and, out_nor, out_xor_wrap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_nor=%h, out_xor_wrap=%h",
                         expected_out_and, expected_out_nor, expected_out_xor_wrap);
                $display("  Got:      out_and=%h, out_nor=%h, out_xor_wrap=%h",
                         out_and, out_nor, out_xor_wrap);
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
