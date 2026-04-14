`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] C;
    wire CARRY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CARRY(CARRY)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'd0;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'd128;
            B = 8'd127;
            $display("Test %0d: Max sum without carry (128 + 127)", test_num);
            #1;

            check_outputs(8'd255, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd1;
            $display("Test %0d: Boundary carry (255 + 1)", test_num);
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            $display("Test %0d: Max values (255 + 255)", test_num);
            #1;

            check_outputs(8'hFE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'h55;
            $display("Test %0d: Alternating bits (0xAA + 0x55)", test_num);
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'd200;
            B = 8'd100;
            $display("Test %0d: Middle range carry (200 + 100)", test_num);
            #1;

            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'hF0;
            B = 8'h00;
            $display("Test %0d: Large number + zero (0xF0 + 0x00)", test_num);
            #1;

            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'd15;
            B = 8'd32;
            $display("Test %0d: Small numbers (15 + 32)", test_num);
            #1;

            check_outputs(8'd47, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'h80;
            B = 8'h80;
            $display("Test %0d: Power of 2 overflow (128 + 128)", test_num);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'h12;
            B = 8'h34;
            $display("Test %0d: Hex addition (0x12 + 0x34)", test_num);
            #1;

            check_outputs(8'h46, 1'b0);
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
        input [7:0] expected_C;
        input expected_CARRY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY)) begin
                $display("PASS");
                $display("  Outputs: C=%h, CARRY=%b",
                         C, CARRY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, CARRY=%b",
                         expected_C, expected_CARRY);
                $display("  Got:      C=%h, CARRY=%b",
                         C, CARRY);
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
