`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] cmd;
    wire [15:0] rLeft;
    wire [15:0] rRight;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cmd(cmd),
        .rLeft(rLeft),
        .rRight(rRight),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Addition", test_num);
            a = 16'h1234;
            b = 16'h1111;
            cmd = 4'h0;

            #1;


            check_outputs(16'h2345, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Subtraction", test_num);
            a = 16'h0010;
            b = 16'h0001;
            cmd = 4'h1;

            #1;


            check_outputs(16'h000F, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Bitwise AND", test_num);
            a = 16'hAAAA;
            b = 16'hF0F0;
            cmd = 4'h2;

            #1;


            check_outputs(16'hA0A0, 16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Bitwise OR", test_num);
            a = 16'h1234;
            b = 16'h4321;
            cmd = 4'h3;

            #1;


            check_outputs(16'h5375, 16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Bitwise XOR", test_num);
            a = 16'hFFFF;
            b = 16'h1234;
            cmd = 4'h4;

            #1;


            check_outputs(16'hEDCB, 16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Logical Shift Left", test_num);
            a = 16'h0001;
            b = 16'h0004;
            cmd = 4'h5;

            #1;


            check_outputs(16'h0010, 16'h0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Logical Shift Right", test_num);
            a = 16'h8000;
            b = 16'h0002;
            cmd = 4'h6;

            #1;


            check_outputs(16'h2000, 16'h0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Multiplication Small", test_num);
            a = 16'h0010;
            b = 16'h0005;
            cmd = 4'h7;

            #1;


            check_outputs(16'h0000, 16'h0050, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Multiplication Large", test_num);
            a = 16'hFFFF;
            b = 16'h0002;
            cmd = 4'h7;

            #1;


            check_outputs(16'h0001, 16'hFFFE, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Zero Flag", test_num);
            a = 16'h1234;
            b = 16'h1234;
            cmd = 4'h4;

            #1;


            check_outputs(16'h0000, 16'h0000, 1'b1);
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
        input [15:0] expected_rLeft;
        input [15:0] expected_rRight;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rLeft === (expected_rLeft ^ rLeft ^ expected_rLeft) &&
                expected_rRight === (expected_rRight ^ rRight ^ expected_rRight) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: rLeft=%h, rRight=%h, zero=%b",
                         rLeft, rRight, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rLeft=%h, rRight=%h, zero=%b",
                         expected_rLeft, expected_rRight, expected_zero);
                $display("  Got:      rLeft=%h, rRight=%h, zero=%b",
                         rLeft, rRight, zero);
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
