`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = test_num + 1;
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checkerboard Complementary");
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Identity with 0xFF");
            test_num = test_num + 1;
            A = 8'h12;
            B = 8'hFF;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero with 0x00");
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Nibble Isolation (High)");
            test_num = test_num + 1;
            A = 8'hF0;
            B = 8'hAB;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Nibble Isolation (Low)");
            test_num = test_num + 1;
            A = 8'h0F;
            B = 8'hAB;
            #1;

            check_outputs(8'h0B);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Specific Bit Patterns");
            test_num = test_num + 1;
            A = 8'b11100111;
            B = 8'b00111011;

            #1;


            check_outputs(8'h23);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Alternating Bits Masking");
            test_num = test_num + 1;
            A = 8'h55;
            B = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary Bits");
            test_num = test_num + 1;
            A = 8'h81;
            B = 8'hC3;
            #1;

            check_outputs(8'h81);
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
