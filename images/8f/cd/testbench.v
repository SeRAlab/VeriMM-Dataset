`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg carry;
    reg [15:0] data;
    wire carry_flag;
    wire negative_flag;
    wire overflow_flag;
    wire zd_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry(carry),
        .data(data),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag),
        .zd_flag(zd_flag)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Data=0, Carry=0", test_num);
            data = 16'h0000;
            carry = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Data=0, Carry=1", test_num);
            data = 16'h0000;
            carry = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Data=0x8000 (Min Negative), Carry=0", test_num);
            data = 16'h8000;
            carry = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data=0x8000 (Min Negative), Carry=1", test_num);
            data = 16'h8000;
            carry = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data=0x7FFF (Max Positive), Carry=0", test_num);
            data = 16'h7FFF;
            carry = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Data=0x7FFF (Max Positive), Carry=1", test_num);
            data = 16'h7FFF;
            carry = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Data=0xFFFF (-1), Carry=0", test_num);
            data = 16'hFFFF;
            carry = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Data=0x0001 (Small Positive), Carry=1", test_num);
            data = 16'h0001;
            carry = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
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
        input expected_carry_flag;
        input expected_negative_flag;
        input expected_overflow_flag;
        input expected_zd_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_flag === (expected_carry_flag ^ carry_flag ^ expected_carry_flag) &&
                expected_negative_flag === (expected_negative_flag ^ negative_flag ^ expected_negative_flag) &&
                expected_overflow_flag === (expected_overflow_flag ^ overflow_flag ^ expected_overflow_flag) &&
                expected_zd_flag === (expected_zd_flag ^ zd_flag ^ expected_zd_flag)) begin
                $display("PASS");
                $display("  Outputs: carry_flag=%b, negative_flag=%b, overflow_flag=%b, zd_flag=%b",
                         carry_flag, negative_flag, overflow_flag, zd_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_flag=%b, negative_flag=%b, overflow_flag=%b, zd_flag=%b",
                         expected_carry_flag, expected_negative_flag, expected_overflow_flag, expected_zd_flag);
                $display("  Got:      carry_flag=%b, negative_flag=%b, overflow_flag=%b, zd_flag=%b",
                         carry_flag, negative_flag, overflow_flag, zd_flag);
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
