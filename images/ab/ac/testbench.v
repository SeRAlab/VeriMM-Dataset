`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (15 + 10)", test_num);
            A = 8'd15;
            B = 8'd10;
            op = 3'b000;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            op = 3'b000;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            A = 8'd50;
            B = 8'd20;
            op = 3'b001;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Wrap (10 - 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            op = 3'b001;
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 5)", test_num);
            A = 8'd12;
            B = 8'd5;
            op = 3'b010;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (64 * 8)", test_num);
            A = 8'd64;
            B = 8'd8;
            op = 3'b010;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 4)", test_num);
            A = 8'd100;
            B = 8'd4;
            op = 3'b011;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero (50 / 0)", test_num);
            A = 8'd50;
            B = 8'd0;
            op = 3'b011;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Op Code (op=100)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            op = 3'b100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Op Code (op=111)", test_num);
            A = 8'd10;
            B = 8'd10;
            op = 3'b111;
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
        input [7:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
