`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA_IN;
    wire [7:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .DATA_OUT(DATA_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 0 to 2 (Power of 2)", test_num);

            DATA_IN = 4'd0;
            #1;

            check_outputs(8'h01);

            DATA_IN = 4'd1;
            #1;

            check_outputs(8'h02);

            DATA_IN = 4'd2;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 3 to 5 (Power of 2)", test_num);

            DATA_IN = 4'd3;
            #1;

            check_outputs(8'h08);

            DATA_IN = 4'd4;
            #1;

            check_outputs(8'h10);

            DATA_IN = 4'd5;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 6 to 7 (Power of 2)", test_num);

            DATA_IN = 4'd6;
            #1;

            check_outputs(8'h40);

            DATA_IN = 4'd7;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Special Inputs 8 and 9", test_num);

            DATA_IN = 4'd8;
            #1;

            check_outputs(8'h09);

            DATA_IN = 4'd9;
            #1;

            check_outputs(8'h0B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 10 to 15 (Default zeros)", test_num);

            DATA_IN = 4'd10;
            #1;

            check_outputs(8'h00);

            DATA_IN = 4'd13;
            #1;

            check_outputs(8'h00);

            DATA_IN = 4'd15;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_DATA_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
