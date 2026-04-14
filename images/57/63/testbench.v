`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

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
        test_num = test_num + 1;
        $display("Test Case 001: Zero Multiplication (0 * 0)");

        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;

        A = 8'd0; B = 8'd0;
        #100;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Identity Multiplication (125 * 1)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd125; B = 8'd1;
        #100;
        #1;

        check_outputs(16'd125);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Max Value Multiplication (255 * 255)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'hFF; B = 8'hFF;
        #100;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Power of 2 (16 * 16)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd16; B = 8'd16;
        #100;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Mid-range Boundary (128 * 2)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd128; B = 8'd2;
        #100;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Commutative Check (15 * 10)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd15; B = 8'd10;
        #100;
        #1;

        check_outputs(16'd150);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Zero Multiplier (255 * 0)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd255; B = 8'd0;
        #100;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Prime Numbers (17 * 13)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd17; B = 8'd13;
        #100;
        #1;

        check_outputs(16'd221);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Large and Small (255 * 2)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd255; B = 8'd2;
        #100;
        #1;

        check_outputs(16'd510);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Typical Calculation (123 * 45)");
        rst_n = 0; A = 0; B = 0;
        #20 rst_n = 1;
        A = 8'd123; B = 8'd45;
        #100;
        #1;

        check_outputs(16'd5535);
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
        input [15:0] expected_P;
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
