`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire carry_out;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        a = 4'd0; b = 4'd0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (5 + 3)", test_num);
        a = 4'd5; b = 4'd3;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Max Result No Carry (15 + 0)", test_num);
        a = 4'd15; b = 4'd0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry Generation (8 + 8)", test_num);
        a = 4'd8; b = 4'd8;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry Generation with Remainder (10 + 10)", test_num);
        a = 4'd10; b = 4'd10;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Max Value Overflow (15 + 1)", test_num);
        a = 4'd15; b = 4'd1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Bits Set (15 + 15)", test_num);
        a = 4'd15; b = 4'd15;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (10 + 5)", test_num);
        a = 4'b1010; b = 4'b0101;
        #1;

        check_outputs(1'b0, 4'b1111);
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
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, s=%h",
                         carry_out, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, s=%h",
                         expected_carry_out, expected_s);
                $display("  Got:      carry_out=%b, s=%h",
                         carry_out, s);
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
