`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] A;
    reg [13:0] B;
    wire [32:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All Zeros");
        A = 12'h000;
        B = 14'h0000;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Identity (1 * 1)");
        A = 12'd1;
        B = 14'd1;
        #1;

        check_outputs(33'h000000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Max A * 1");
        A = 12'hFFF;
        B = 14'h0001;
        #1;

        check_outputs(33'h000000FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: 1 * Max B");
        A = 12'h001;
        B = 14'h3FFF;
        #1;

        check_outputs(33'h000003FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Maximum Inputs (4095 * 16383)");
        A = 12'hFFF;
        B = 14'h3FFF;

        #1;


        check_outputs(33'h003FFB001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Power of 2 (2^11 * 2^13)");
        A = 12'h800;
        B = 14'h2000;

        #1;


        check_outputs(33'h001000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Arbitrary Values (0xABC * 0x1234)");
        A = 12'hABC;
        B = 14'h1234;

        #1;


        check_outputs(33'h000C36630);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Alternating bit patterns (0x555 * 0x2AAA)");
        A = 12'h555;
        B = 14'h2AAA;

        #1;


        check_outputs(33'h000E37C72);
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
        input [32:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
