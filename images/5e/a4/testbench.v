`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg signed_unsigned;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .signed_unsigned(signed_unsigned),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'd15;
        B = 8'd25;
        signed_unsigned = 1'b0;
        $display("Test %0d: Unsigned 15 + 25", test_num);
        #1;

        check_outputs(1'b0, 8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'd200;
        B = 8'd100;
        signed_unsigned = 1'b0;

        $display("Test %0d: Unsigned 200 + 100 (Carry expected)", test_num);
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'hFF;
        B = 8'h01;
        signed_unsigned = 1'b0;
        $display("Test %0d: Unsigned 255 + 1", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'd64;
        B = 8'd63;
        signed_unsigned = 1'b1;
        $display("Test %0d: Signed 64 + 63", test_num);
        #1;

        check_outputs(1'b0, 8'd127);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'd127;
        B = 8'd1;
        signed_unsigned = 1'b1;

        $display("Test %0d: Signed 127 + 1 (Overflow bit behavior)", test_num);
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'hFF;
        B = 8'h01;
        signed_unsigned = 1'b1;

        $display("Test %0d: Signed -1 + 1", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'hFE;
        B = 8'hFF;
        signed_unsigned = 1'b1;

        $display("Test %0d: Signed -2 + -1", test_num);
        #1;

        check_outputs(1'b1, 8'hFD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'h80;
        B = 8'hFF;
        signed_unsigned = 1'b1;

        $display("Test %0d: Signed -128 + -1", test_num);
        #1;

        check_outputs(1'b1, 8'h7F);
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
        input expected_carry_out;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
