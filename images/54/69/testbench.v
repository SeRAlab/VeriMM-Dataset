`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bin_val;
    wire [7:0] gray_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_val(bin_val),
        .gray_val(gray_val)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 00000000", test_num);
            bin_val = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 00000001", test_num);
            bin_val = 8'h01;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 00000010", test_num);
            bin_val = 8'h02;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 00000011", test_num);
            bin_val = 8'h03;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 01111111 (Max 7-bit)", test_num);
            bin_val = 8'h7F;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 10000000 (MSB Toggle)", test_num);
            bin_val = 8'h80;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 10101010 (Alternating)", test_num);
            bin_val = 8'hAA;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 01010101 (Alternating)", test_num);
            bin_val = 8'h55;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 11111111 (All High)", test_num);
            bin_val = 8'hFF;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary 11001100", test_num);
            bin_val = 8'hCC;
            #1;

            check_outputs(8'hA6);
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
        input [7:0] expected_gray_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_val === (expected_gray_val ^ gray_val ^ expected_gray_val)) begin
                $display("PASS");
                $display("  Outputs: gray_val=%h",
                         gray_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_val=%h",
                         expected_gray_val);
                $display("  Got:      gray_val=%h",
                         gray_val);
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
