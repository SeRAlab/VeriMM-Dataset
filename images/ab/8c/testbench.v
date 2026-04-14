`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg en;
    reg [1:0] opcode;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .en(en),
        .opcode(opcode),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Inactive (A=10, B=20, op=0)", test_num);
            A = 8'd10;
            B = 8'd20;
            en = 1'b0;
            opcode = 2'b00;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (15 + 25)", test_num);
            A = 8'd15;
            B = 8'd25;
            en = 1'b1;
            opcode = 2'b00;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            en = 1'b1;
            opcode = 2'b00;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (50 - 20)", test_num);
            A = 8'd50;
            B = 8'd20;
            en = 1'b1;
            opcode = 2'b01;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow (10 - 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            en = 1'b1;
            opcode = 2'b01;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (12 * 5)", test_num);
            A = 8'd12;
            B = 8'd5;
            en = 1'b1;
            opcode = 2'b10;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (20 * 20)", test_num);
            A = 8'd20;
            B = 8'd20;
            en = 1'b1;
            opcode = 2'b10;
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (100 / 4)", test_num);
            A = 8'd100;
            B = 8'd4;
            en = 1'b1;
            opcode = 2'b11;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division Truncation (10 / 3)", test_num);
            A = 8'd10;
            B = 8'd3;
            en = 1'b1;
            opcode = 2'b11;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Operands (0 + 0)", test_num);
            A = 8'd0;
            B = 8'd0;
            en = 1'b1;
            opcode = 2'b00;
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
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
