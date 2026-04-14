`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] row1;
    reg [31:0] row2;
    reg [31:0] row3;
    reg [31:0] row4;
    wire [31:0] row1_out;
    wire [31:0] row2_out;
    wire [31:0] row3_out;
    wire [31:0] row4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .row1(row1),
        .row2(row2),
        .row3(row3),
        .row4(row4),
        .row1_out(row1_out),
        .row2_out(row2_out),
        .row3_out(row3_out),
        .row4_out(row4_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Unique byte patterns", test_num);
            row1 = 32'h11223344;
            row2 = 32'h55667788;
            row3 = 32'h99AABBCC;
            row4 = 32'hDDEEFF00;




            #1;





            check_outputs(32'h11223344, 32'h66778855, 32'hBBCC99AA, 32'h00DDEEFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Uniform byte values", test_num);
            row1 = 32'hAAAAAAAA;
            row2 = 32'hBBBBBBBB;
            row3 = 32'hCCCCCCCC;
            row4 = 32'hDDDDDDDD;
            #1;

            check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB, 32'hCCCCCCCC, 32'hDDDDDDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sequential bytes", test_num);
            row1 = 32'h00010203;
            row2 = 32'h04050607;
            row3 = 32'h08090A0B;
            row4 = 32'h0C0D0E0F;




            #1;





            check_outputs(32'h00010203, 32'h05060704, 32'h0A0B0809, 32'h0F0C0D0E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating bit patterns", test_num);
            row1 = 32'hFFFF0000;
            row2 = 32'hFF00FF00;
            row3 = 32'hCCCC3333;
            row4 = 32'h5555AAAA;




            #1;





            check_outputs(32'hFFFF0000, 32'h00FF00FF, 32'h3333CCCC, 32'hAA5555AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All zeros and all ones", test_num);
            row1 = 32'h00000000;
            row2 = 32'hFFFFFFFF;
            row3 = 32'h00000000;
            row4 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF, 32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mixed crypto-style data", test_num);
            row1 = 32'hD4E0B81E;
            row2 = 32'hBFB44127;
            row3 = 32'h5D521198;
            row4 = 32'h30AEF1E5;




            #1;





            check_outputs(32'hD4E0B81E, 32'hB44127BF, 32'h11985D52, 32'hE530AEF1);
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
        input [31:0] expected_row1_out;
        input [31:0] expected_row2_out;
        input [31:0] expected_row3_out;
        input [31:0] expected_row4_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_row1_out === (expected_row1_out ^ row1_out ^ expected_row1_out) &&
                expected_row2_out === (expected_row2_out ^ row2_out ^ expected_row2_out) &&
                expected_row3_out === (expected_row3_out ^ row3_out ^ expected_row3_out) &&
                expected_row4_out === (expected_row4_out ^ row4_out ^ expected_row4_out)) begin
                $display("PASS");
                $display("  Outputs: row1_out=%h, row2_out=%h, row3_out=%h, row4_out=%h",
                         row1_out, row2_out, row3_out, row4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: row1_out=%h, row2_out=%h, row3_out=%h, row4_out=%h",
                         expected_row1_out, expected_row2_out, expected_row3_out, expected_row4_out);
                $display("  Got:      row1_out=%h, row2_out=%h, row3_out=%h, row4_out=%h",
                         row1_out, row2_out, row3_out, row4_out);
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
