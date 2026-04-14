`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire carry;
    wire overflow;
    wire parity;
    wire sign;
    wire [15:0] z;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .carry(carry),
        .overflow(overflow),
        .parity(parity),
        .sign(sign),
        .z(z),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 10)", test_num);
            x = 16'd5; y = 16'd10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 16'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Result (0 + 0)", test_num);
            x = 16'h0000; y = 16'h0000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign Flag (0x0001 + 0x8000)", test_num);
            x = 16'h0001; y = 16'h8000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 16'h8001, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Flag (0xFFFF + 0x0001)", test_num);
            x = 16'hFFFF; y = 16'h0001;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Overflow Pos+Pos (0x7FFF + 0x0001)", test_num);
            x = 16'h7FFF; y = 16'h0001;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 16'h8000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Overflow Neg+Neg (0x8000 + 0x8000)", test_num);
            x = 16'h8000; y = 16'h8000;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parity Flag - Odd (0x0001 + 0x0000)", test_num);
            x = 16'h0001; y = 16'h0000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 16'h0001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Numbers (0x1234 + 0xABCD)", test_num);
            x = 16'h1234; y = 16'hABCD;




            #1;





            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 16'hBE01, 1'b0);
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
        input expected_carry;
        input expected_overflow;
        input expected_parity;
        input expected_sign;
        input [15:0] expected_z;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign) &&
                expected_z === (expected_z ^ z ^ expected_z) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, overflow=%b, parity=%b, sign=%b, z=%h, zero=%b",
                         carry, overflow, parity, sign, z, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, overflow=%b, parity=%b, sign=%b, z=%h, zero=%b",
                         expected_carry, expected_overflow, expected_parity, expected_sign, expected_z, expected_zero);
                $display("  Got:      carry=%b, overflow=%b, parity=%b, sign=%b, z=%h, zero=%b",
                         carry, overflow, parity, sign, z, zero);
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
