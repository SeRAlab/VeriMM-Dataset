`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] E;
    reg [7:0] F;
    reg [7:0] G;
    reg [7:0] H;
    wire [1:0] F_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .F_out(F_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs zero");
            test_num = 1;
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
            E = 8'h00; F = 8'h00; G = 8'h00; H = 8'h00;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All inputs 0xFF");
            test_num = 2;
            A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF;
            E = 8'hFF; F = 8'hFF; G = 8'hFF; H = 8'hFF;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: First group active (ABCD), second group inactive");
            test_num = 3;
            A = 8'hFF; B = 8'hFF; C = 8'h00; D = 8'h00;
            E = 8'h00; F = 8'h00; G = 8'h00; H = 8'h00;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Second group active (EFGH), first group inactive");
            test_num = 4;
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
            E = 8'hFF; F = 8'hFF; G = 8'hFF; H = 8'hFF;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise combination (OR-ing to FF)");
            test_num = 5;
            A = 8'hAA; B = 8'hFF;
            C = 8'h55; D = 8'hFF;
            E = 8'h0F; F = 8'hFF;
            G = 8'hF0; H = 8'hFF;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise combination (OR-ing to almost FF)");
            test_num = 6;
            A = 8'hA0; B = 8'hFF;
            C = 8'h50; D = 8'hFF;
            E = 8'h00; F = 8'h00;
            G = 8'h00; H = 8'h00;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Mixed partial bits");
            test_num = 7;
            A = 8'hFE; B = 8'hFF;
            C = 8'h00; D = 8'h00;
            E = 8'hFF; F = 8'hFF;
            G = 8'hFF; H = 8'hFF;


            #1;



            check_outputs(2'b01);
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
        input [1:0] expected_F_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F_out === (expected_F_out ^ F_out ^ expected_F_out)) begin
                $display("PASS");
                $display("  Outputs: F_out=%h",
                         F_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F_out=%h",
                         expected_F_out);
                $display("  Got:      F_out=%h",
                         F_out);
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
