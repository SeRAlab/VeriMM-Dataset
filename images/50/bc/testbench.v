`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd_in;
    wire [7:0] bin_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_in(bcd_in),
        .bin_out(bin_out)
    );
    task testcase001;

        begin
            test_num = 1;
            bcd_in = 4'd0;
            $display("Test %0d: Input BCD 0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bcd_in = 4'd1;
            $display("Test %0d: Input BCD 1", test_num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bcd_in = 4'd5;
            $display("Test %0d: Input BCD 5", test_num);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bcd_in = 4'd9;
            $display("Test %0d: Input BCD 9 (Valid Upper Boundary)", test_num);
            #1;

            check_outputs(8'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            bcd_in = 4'd10;
            $display("Test %0d: Input BCD 10 (Invalid Case - Boundary)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            bcd_in = 4'd15;
            $display("Test %0d: Input BCD 15 (Invalid Case - Max Value)", test_num);
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_bin_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin_out === (expected_bin_out ^ bin_out ^ expected_bin_out)) begin
                $display("PASS");
                $display("  Outputs: bin_out=%h",
                         bin_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin_out=%h",
                         expected_bin_out);
                $display("  Got:      bin_out=%h",
                         bin_out);
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
