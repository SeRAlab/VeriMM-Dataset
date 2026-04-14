`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [9:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 8'h00;
            $display("Test Case 001: Input 8'h00 (Expect 10'h001)");
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 8'h01;
            $display("Test Case 002: Input 8'h01 (Expect 10'h002)");
            #1;

            check_outputs(10'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 8'h02;
            $display("Test Case 003: Input 8'h02 (Expect 10'h004)");
            #1;

            check_outputs(10'h004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 8'h03;
            $display("Test Case 004: Input 8'h03 (Expect 10'h008)");
            #1;

            check_outputs(10'h008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 8'h04;
            $display("Test Case 005: Input 8'h04 (Expect 10'h010)");
            #1;

            check_outputs(10'h010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 8'h05;
            $display("Test Case 006: Input 8'h05 (Expect 10'h020)");
            #1;

            check_outputs(10'h020);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 8'h06;
            $display("Test Case 007: Input 8'h06 (Expect 10'h040)");
            #1;

            check_outputs(10'h040);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 8'h07;
            $display("Test Case 008: Input 8'h07 (Expect 10'h080)");
            #1;

            check_outputs(10'h080);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 8'h08;
            $display("Test Case 009: Input 8'h08 (Expect 10'h100)");
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 8'h09;
            $display("Test Case 010: Input 8'h09 (Expect 10'h200)");
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data_in = 8'h0A;
            $display("Test Case 011: Input 8'h0A (Undefined mapping, Expect 10'h000)");
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data_in = 8'hFF;
            $display("Test Case 012: Input 8'hFF (Undefined mapping, Expect 10'h000)");
            #1;

            check_outputs(10'h000);
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
        input [9:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
