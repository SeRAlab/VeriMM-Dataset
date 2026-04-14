`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] alpha_current;
    reg [17:0] beta_current;
    reg [17:0] cos_coefficient;
    reg [17:0] sin_coefficient;
    wire [17:0] direct_current;
    wire [17:0] quadrature_current;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alpha_current(alpha_current),
        .beta_current(beta_current),
        .cos_coefficient(cos_coefficient),
        .sin_coefficient(sin_coefficient),
        .direct_current(direct_current),
        .quadrature_current(quadrature_current)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All inputs zero");
        alpha_current = 18'h0;
        beta_current = 18'h0;
        cos_coefficient = 18'h0;
        sin_coefficient = 18'h0;
        #1;

        check_outputs(18'h0, 18'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Identity (Theta=0)");
        alpha_current = 18'd1000;
        beta_current = 18'd0;
        cos_coefficient = 18'h08000;
        sin_coefficient = 18'h00000;
        #1;

        check_outputs(18'd1000, 18'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: 90-degree rotation");
        alpha_current = 18'd1000;
        beta_current = 18'd0;
        cos_coefficient = 18'h00000;
        sin_coefficient = 18'h08000;
        #1;

        check_outputs(18'h0, 18'h3FC18);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Beta current only (Theta=0)");
        alpha_current = 18'd0;
        beta_current = 18'd1000;
        cos_coefficient = 18'h08000;
        sin_coefficient = 18'h00000;
        #1;

        check_outputs(18'd0, 18'd1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: 180-degree rotation");
        alpha_current = 18'd1000;
        beta_current = 18'd1000;
        cos_coefficient = 18'h38000;
        sin_coefficient = 18'h00000;
        #1;

        check_outputs(18'h3FC18, 18'h3FC18);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: 45-degree rotation");
        alpha_current = 18'd1000;
        beta_current = 18'd0;
        cos_coefficient = 18'd23170;
        sin_coefficient = 18'd23170;
        #1;

        check_outputs(18'd707, 18'h3FD3D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Negative current inputs");
        alpha_current = 18'h3FE0C;
        beta_current = 18'h3FE0C;
        cos_coefficient = 18'h08000;
        sin_coefficient = 18'h00000;
        #1;

        check_outputs(18'h3FE0C, 18'h3FE0C);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: High magnitude scaling");
        alpha_current = 18'd16384;
        beta_current = 18'd16384;
        cos_coefficient = 18'd16384;
        sin_coefficient = 18'd16384;
        #1;

        check_outputs(18'd16384, 18'd0);
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
        input [17:0] expected_direct_current;
        input [17:0] expected_quadrature_current;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_direct_current === (expected_direct_current ^ direct_current ^ expected_direct_current) &&
                expected_quadrature_current === (expected_quadrature_current ^ quadrature_current ^ expected_quadrature_current)) begin
                $display("PASS");
                $display("  Outputs: direct_current=%h, quadrature_current=%h",
                         direct_current, quadrature_current);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direct_current=%h, quadrature_current=%h",
                         expected_direct_current, expected_quadrature_current);
                $display("  Got:      direct_current=%h, quadrature_current=%h",
                         direct_current, quadrature_current);
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
