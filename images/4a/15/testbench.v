`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Cin;
    wire Cout;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd20;
            Cin = 1'b0;
            $display("Test %0d: Simple Addition (10 + 20)", test_num);
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd15;
            B = 8'd25;
            Cin = 1'b1;
            $display("Test %0d: Addition with Cin (15 + 25 + 1)", test_num);
            #1;

            check_outputs(1'b0, 8'd41);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'h55;
            B = 8'hAA;
            Cin = 1'b0;
            $display("Test %0d: Max Sum without Carry-out (0x55 + 0xAA)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hFF;
            B = 8'h00;
            Cin = 1'b1;
            $display("Test %0d: Minimal Carry-out (255 + 0 + 1)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'h00;
            B = 8'h00;
            Cin = 1'b0;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'hFF;
            Cin = 1'b1;
            $display("Test %0d: Absolute Maximum Inputs (255 + 255 + 1)", test_num);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd128;
            B = 8'd128;
            Cin = 1'b0;
            $display("Test %0d: Middle Range Overflow (128 + 128)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'b10101010;
            B = 8'b01010101;
            Cin = 1'b1;
            $display("Test %0d: Alternating Bits with Cin", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'd200;
            B = 8'd100;
            Cin = 1'b0;
            $display("Test %0d: Large Value Addition (200 + 100)", test_num);
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'hF0;
            B = 8'h10;
            Cin = 1'b0;
            $display("Test %0d: Zero Sum with Carry-out (0xF0 + 0x10)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
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
        input expected_Cout;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
