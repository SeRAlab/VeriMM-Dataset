`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg carry_in;
    reg sub_enable;
    wire carry_out;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sub_enable(sub_enable),
        .carry_out(carry_out),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 3)", test_num);
            a = 8'd5;
            b = 8'd3;
            sub_enable = 1'b0;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 8'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-in (10 + 20 + 1)", test_num);
            a = 8'd10;
            b = 8'd20;
            sub_enable = 1'b0;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b0, 8'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            sub_enable = 1'b0;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard Subtraction (15 - 5)", test_num);
            a = 8'd15;
            b = 8'd5;
            sub_enable = 1'b1;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b1, 8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction A < B (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            sub_enable = 1'b1;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b0, 8'hFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Borrow (10 - 5 - 1)", test_num);
            a = 8'd10;
            b = 8'd5;
            sub_enable = 1'b1;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b1, 8'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (0 - 0)", test_num);
            a = 8'd0;
            b = 8'd0;
            sub_enable = 1'b1;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values (255 + 255 + 1)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            sub_enable = 1'b0;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits", test_num);
            a = 8'hAA;
            b = 8'h55;
            sub_enable = 1'b0;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Subtraction (0 - 1)", test_num);
            a = 8'h00;
            b = 8'h01;
            sub_enable = 1'b1;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b0, 8'hFF);
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
        input expected_carry_out;
        input [7:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, res=%h",
                         carry_out, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, res=%h",
                         expected_carry_out, expected_res);
                $display("  Got:      carry_out=%b, res=%h",
                         carry_out, res);
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
