`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg G1;
    reg G2A;
    reg G2B;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .G1(G1),
        .G2A(G2A),
        .G2B(G2B),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enabled, A=0");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b000;
            #1;

            check_outputs(8'b11111110);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enabled, A=1");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b001;
            #1;

            check_outputs(8'b11111101);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enabled, A=2");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b010;
            #1;

            check_outputs(8'b11111011);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enabled, A=3");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b011;
            #1;

            check_outputs(8'b11110111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enabled, A=4");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b100;
            #1;

            check_outputs(8'b11101111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enabled, A=5");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b101;
            #1;

            check_outputs(8'b11011111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enabled, A=6");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b110;
            #1;

            check_outputs(8'b10111111);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enabled, A=7");
            G1 = 1; G2A = 0; G2B = 0; A = 3'b111;
            #1;

            check_outputs(8'b01111111);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Disabled (G1=0)");
            G1 = 0; G2A = 0; G2B = 0; A = 3'b000;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Disabled (G2A=1)");
            G1 = 1; G2A = 1; G2B = 0; A = 3'b101;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Disabled (G2B=1)");
            G1 = 1; G2A = 0; G2B = 1; A = 3'b111;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Multiple Disable conditions active");
            G1 = 0; G2A = 1; G2B = 1; A = 3'b010;
            #1;

            check_outputs(8'b11111111);
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
