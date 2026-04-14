`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] op;
    wire [7:0] C;
    wire div0;
    wire ovf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .C(C),
        .div0(div0),
        .ovf(ovf)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition - Positive + Positive (No Overflow)", test_num);
            A = 8'd25;
            B = 8'd30;
            op = 2'b00;
            #1;

            check_outputs(8'd55, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition - Negative + Negative (No Overflow)", test_num);
            A = -8'd15;
            B = -8'd20;
            op = 2'b00;
            #1;

            check_outputs(-8'd35, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition - Positive Overflow", test_num);
            A = 8'd120;
            B = 8'd10;
            op = 2'b00;

            #1;


            check_outputs(8'sb10000010, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition - Negative Overflow", test_num);
            A = -8'd120;
            B = -8'd10;
            op = 2'b00;

            #1;


            check_outputs(8'sb01111110, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction - Positive - Negative (No Overflow)", test_num);
            A = 8'd40;
            B = -8'd10;
            op = 2'b01;
            #1;

            check_outputs(8'd50, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction - Positive Overflow", test_num);
            A = 8'd100;
            B = -8'd50;
            op = 2'b01;

            #1;


            check_outputs(8'sb10010110, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction - Negative Overflow", test_num);
            A = -8'd100;
            B = 8'd50;
            op = 2'b01;

            #1;


            check_outputs(8'sb01101010, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication - Small Product", test_num);
            A = 8'sd10;
            B = -8'sd5;
            op = 2'b10;
            #1;

            check_outputs(-8'sd50, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication - Overflow", test_num);
            A = 8'sd20;
            B = 8'sd10;
            op = 2'b10;

            #1;


            check_outputs(8'sb11001000, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division - Simple", test_num);
            A = 8'sd100;
            B = 8'sd4;
            op = 2'b11;
            #1;

            check_outputs(8'sd25, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division - By Zero", test_num);
            A = 8'sd50;
            B = 8'sd0;
            op = 2'b11;
            #1;

            check_outputs(C, 1'b1, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division - Special Overflow (-128 / -1)", test_num);
            A = -8'sd128;
            B = -8'sd1;
            op = 2'b11;

            #1;


            check_outputs(8'sb10000000, 1'b0, 1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_C;
        input expected_div0;
        input expected_ovf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_div0 === (expected_div0 ^ div0 ^ expected_div0) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf)) begin
                $display("PASS");
                $display("  Outputs: C=%h, div0=%b, ovf=%b",
                         C, div0, ovf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, div0=%b, ovf=%b",
                         expected_C, expected_div0, expected_ovf);
                $display("  Got:      C=%h, div0=%b, ovf=%b",
                         C, div0, ovf);
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
