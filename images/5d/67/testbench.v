`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sub;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sub(sub),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Simple addition (10 + 5)");
            A = 8'd10;
            B = 8'd5;
            sub = 1'b0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple subtraction (10 - 5)");
            A = 8'd10;
            B = 8'd5;
            sub = 1'b1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition with zero");
            A = 8'hFF;
            B = 8'h00;
            sub = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction resulting in zero");
            A = 8'd128;
            B = 8'd128;
            sub = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition with overflow (200 + 100)");
            A = 8'd200;
            B = 8'd100;
            sub = 1'b0;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction with underflow (5 - 10)");
            A = 8'd5;
            B = 8'd10;
            sub = 1'b1;

            #1;


            check_outputs(8'd251);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Maximum value addition (255 + 255)");
            A = 8'hFF;
            B = 8'hFF;
            sub = 1'b0;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Subtracting max from zero (0 - 255)");
            A = 8'h00;
            B = 8'hFF;
            sub = 1'b1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Addition boundary (127 + 1)");
            A = 8'd127;
            B = 8'd1;
            sub = 1'b0;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Subtraction boundary (128 - 1)");
            A = 8'd128;
            B = 8'd1;
            sub = 1'b1;
            #1;

            check_outputs(8'd127);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
