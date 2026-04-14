`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero multiplication");

            A = 4'd0; B = 4'd0;
            #1;

            check_outputs(8'h00);


            A = 4'd5; B = 4'd0;
            #1;

            check_outputs(8'h00);


            A = 4'd0; B = 4'sb1101;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Positive * Positive");

            A = 4'd3; B = 4'd2;
            #1;

            check_outputs(8'h06);


            A = 4'd7; B = 4'd1;
            #1;

            check_outputs(8'h07);


            A = 4'd2; B = 4'd4;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Positive * Negative");

            A = 4'sb0011; B = 4'sb1110;
            #1;

            check_outputs(8'hFA);


            A = 4'sb0111; B = 4'sb1111;
            #1;

            check_outputs(8'hF9);


            A = 4'sb0001; B = 4'sb1000;
            #1;

            check_outputs(8'hF8);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Negative * Positive");

            A = 4'sb1101; B = 4'sb0010;
            #1;

            check_outputs(8'hFA);


            A = 4'sb1000; B = 4'sb0001;
            #1;

            check_outputs(8'hF8);


            A = 4'sb1111; B = 4'sb0111;
            #1;

            check_outputs(8'hF9);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Negative * Negative");

            A = 4'sb1101; B = 4'sb1110;
            #1;

            check_outputs(8'h06);


            A = 4'sb1000; B = 4'sb1111;
            #1;

            check_outputs(8'h08);


            A = 4'sb1100; B = 4'sb1100;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Edge Cases (Min/Max values)");

            A = 4'sb0111; B = 4'sb0111;
            #1;

            check_outputs(8'h31);


            A = 4'sb1000; B = 4'sb0111;
            #1;

            check_outputs(8'hC8);


            A = 4'sb1000; B = 4'sb1000;
            #1;

            check_outputs(8'h40);


            A = 4'sb1111; B = 4'sb1111;
            #1;

            check_outputs(8'h01);
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
