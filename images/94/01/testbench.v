`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [4:0] shift;
    wire [31:0] OA;
    wire [31:0] OB;
    wire [31:0] OC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .shift(shift),
        .OA(OA),
        .OB(OB),
        .OC(OC)
    );
    task testcase001;

    begin
        $display("\nRunning Testcase 001: All Zeros");

        a = 32'h00000000;
        b = 32'h00000000;
        c = 32'h00000000;
        shift = 5'd0;
        clk = 0;

        #10;
        clk = 1;
        #10;
        clk = 0;

        #1;


        check_outputs(32'h00000000, 32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Standard Hex Patterns");

        a = 0; b = 0; c = 0; shift = 0; clk = 0; #10;

        a = 32'h12345678;
        b = 32'h87654321;
        c = 32'hABCDEF01;
        shift = 5'd0;

        #10;
        clk = 1;
        #10;
        clk = 0;

        #1;


        check_outputs(32'h12345678, 32'h87654321, 32'hABCDEF01);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: All Ones");

        a = 0; b = 0; c = 0; shift = 0; clk = 0; #10;

        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        c = 32'hFFFFFFFF;
        shift = 5'd31;

        #10;
        clk = 1;
        #10;
        clk = 0;

        #1;


        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Alternating Bits");

        a = 0; b = 0; c = 0; shift = 0; clk = 0; #10;

        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        c = 32'hF0F0F0F0;
        shift = 5'd16;

        #10;
        clk = 1;
        #10;
        clk = 0;

        #1;


        check_outputs(32'hAAAAAAAA, 32'h55555555, 32'hF0F0F0F0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Mixed Small Values");

        a = 0; b = 0; c = 0; shift = 0; clk = 0; #10;

        a = 32'd100;
        b = 32'd200;
        c = 32'd300;
        shift = 5'd5;

        #10;
        clk = 1;
        #10;
        clk = 0;

        #1;


        check_outputs(32'd100, 32'd200, 32'd300);
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
        input [31:0] expected_OA;
        input [31:0] expected_OB;
        input [31:0] expected_OC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OA === (expected_OA ^ OA ^ expected_OA) &&
                expected_OB === (expected_OB ^ OB ^ expected_OB) &&
                expected_OC === (expected_OC ^ OC ^ expected_OC)) begin
                $display("PASS");
                $display("  Outputs: OA=%h, OB=%h, OC=%h",
                         OA, OB, OC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OA=%h, OB=%h, OC=%h",
                         expected_OA, expected_OB, expected_OC);
                $display("  Got:      OA=%h, OB=%h, OC=%h",
                         OA, OB, OC);
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
