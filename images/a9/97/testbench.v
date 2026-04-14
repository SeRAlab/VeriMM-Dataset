`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    reg [3:0] comp_in_1;
    reg [3:0] comp_in_2;
    wire comp_out;
    wire [3:0] gray_out;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .comp_in_1(comp_in_1),
        .comp_in_2(comp_in_2),
        .comp_out(comp_out),
        .gray_out(gray_out),
        .shift_out(shift_out)
    );
    task testcase001;

        begin
            test_num = 1;
            binary_in = 4'd0;
            comp_in_1 = 4'd1;
            comp_in_2 = 4'd0;

            #1;


            check_outputs(1'b1, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_in = 4'd5;
            comp_in_1 = 4'd8;
            comp_in_2 = 4'd4;

            #1;


            check_outputs(1'b1, 4'b0111, 4'b1110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_in = 4'd10;
            comp_in_1 = 4'd2;
            comp_in_2 = 4'd8;

            #1;


            check_outputs(1'b0, 4'b1111, 4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_in = 4'd15;
            comp_in_1 = 4'd7;
            comp_in_2 = 4'd7;

            #1;


            check_outputs(1'b1, 4'b1000, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_in = 4'd1;
            comp_in_1 = 4'd3;
            comp_in_2 = 4'd12;

            #1;


            check_outputs(1'b0, 4'b0001, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_in = 4'd8;
            comp_in_1 = 4'd10;
            comp_in_2 = 4'd2;

            #1;


            check_outputs(1'b1, 4'b1100, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_in = 4'd12;
            comp_in_1 = 4'd15;
            comp_in_2 = 4'd15;

            #1;


            check_outputs(1'b1, 4'b1010, 4'b1010);
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
        input expected_comp_out;
        input [3:0] expected_gray_out;
        input [3:0] expected_shift_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp_out === (expected_comp_out ^ comp_out ^ expected_comp_out) &&
                expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: comp_out=%b, gray_out=%h, shift_out=%h",
                         comp_out, gray_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp_out=%b, gray_out=%h, shift_out=%h",
                         expected_comp_out, expected_gray_out, expected_shift_out);
                $display("  Got:      comp_out=%b, gray_out=%h, shift_out=%h",
                         comp_out, gray_out, shift_out);
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
