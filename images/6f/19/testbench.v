`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin_in;
    wire [15:0] dec_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .dec_out(dec_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Binary Input 0000", test_num);
            bin_in = 4'b0000;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Binary Input 0001", test_num);
            bin_in = 4'b0001;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Binary Input 0101 (5)", test_num);
            bin_in = 4'b0101;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Binary Input 1010 (10)", test_num);
            bin_in = 4'b1010;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Binary Input 1111 (15)", test_num);
            bin_in = 4'b1111;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Binary Input 1000 (8)", test_num);
            bin_in = 4'b1000;
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Binary Input 0011 (3)", test_num);
            bin_in = 4'b0011;
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Binary Input 0111 (7)", test_num);
            bin_in = 4'b0111;
            #1;

            check_outputs(16'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Binary Input 1110 (14)", test_num);
            bin_in = 4'b1110;
            #1;

            check_outputs(16'd14);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Binary Input 0100 (4)", test_num);
            bin_in = 4'b0100;
            #1;

            check_outputs(16'd4);
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
        input [15:0] expected_dec_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec_out === (expected_dec_out ^ dec_out ^ expected_dec_out)) begin
                $display("PASS");
                $display("  Outputs: dec_out=%h",
                         dec_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_out=%h",
                         expected_dec_out);
                $display("  Got:      dec_out=%h",
                         dec_out);
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
