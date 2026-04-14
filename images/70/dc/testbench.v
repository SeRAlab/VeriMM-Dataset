`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] in;
    wire [18:0] out_and;
    wire [18:0] out_nor;
    wire [19:0] out_xor_wrap;

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
            test_num = test_num + 1;
            in = 20'h00000;
            #1;

            check_outputs(19'h00000, 19'h7FFFF, 20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 20'hFFFFF;
            #1;

            check_outputs(19'h7FFFF, 19'h00000, 20'h00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 20'h55555;
            #1;

            check_outputs(19'h00000, 19'h00000, 20'hFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 20'hAAAAA;
            #1;

            check_outputs(19'h00000, 19'h00000, 20'hFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 20'h00001;
            #1;

            check_outputs(19'h00000, 19'h7FFFE, 20'h00003);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 20'h80000;
            #1;

            check_outputs(19'h00000, 19'h3FFFF, 20'h80001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 20'h00003;
            #1;

            check_outputs(19'h00001, 19'h7FFFC, 20'h00005);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 20'hC0000;
            #1;

            check_outputs(19'h40000, 19'h1FFFF, 20'h40001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in = 20'hF000F;
            #1;

            check_outputs(19'h70007, 19'h07FF0, 20'h10010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in = 20'hF0F0F;
            #1;

            check_outputs(19'h70707, 19'h07070, 20'h11110);
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
        input [18:0] expected_out_and;
        input [18:0] expected_out_nor;
        input [19:0] expected_out_xor_wrap;
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
