`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg BINV;
    reg CIN;
    reg [1:0] OP;
    wire COUT;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .BINV(BINV),
        .CIN(CIN),
        .OP(OP),
        .COUT(COUT),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (3 + 2)", test_num);
            A = 4'd3; B = 4'd2; CIN = 0; BINV = 0; OP = 2'b00;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with Carry (15 + 1 + CIN=0)", test_num);
            A = 4'hf; B = 4'h1; CIN = 0; BINV = 0; OP = 2'b00;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with CIN (5 + 5 + 1)", test_num);
            A = 4'd5; B = 4'd5; CIN = 1; BINV = 0; OP = 2'b00;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (10 - 4)", test_num);
            A = 4'd10; B = 4'd4; CIN = 0; BINV = 0; OP = 2'b01;
            #1;

            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (4 - 10)", test_num);
            A = 4'd4; B = 4'd10; CIN = 0; BINV = 0; OP = 2'b01;
            #1;

            check_outputs(1'b0, 4'ha);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Logical AND", test_num);
            A = 4'b1100; B = 4'b1010; CIN = 0; BINV = 0; OP = 2'b10;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Logical OR (using BINV)", test_num);
            A = 4'b1100; B = 4'b1010; CIN = 0; BINV = 1; OP = 2'b10;
            #1;

            check_outputs(1'b0, 4'b1110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Left (1001 << 1)", test_num);
            A = 4'b1001; B = 4'b0000; CIN = 0; BINV = 0; OP = 2'b11;
            #1;

            check_outputs(1'b1, 4'b0010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Right (1001 >> 1)", test_num);
            A = 4'b1001; B = 4'b0000; CIN = 0; BINV = 1; OP = 2'b11;
            #1;

            check_outputs(1'b1, 4'b0100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            A = 4'h0; B = 4'h0; CIN = 0; BINV = 0; OP = 2'b00;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input expected_COUT;
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, Y=%h",
                         COUT, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, Y=%h",
                         expected_COUT, expected_Y);
                $display("  Got:      COUT=%b, Y=%h",
                         COUT, Y);
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
