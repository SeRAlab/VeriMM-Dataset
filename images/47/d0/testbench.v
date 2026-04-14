`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] vec;
    wire [1:0] outs;
    wire [1:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vec(vec),
        .outs(outs),
        .outv(outv)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: vec = 4'b0000 (All zeros)");
        vec = 4'b0000;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: vec = 4'b1111 (All ones)");
        vec = 4'b1111;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: vec = 4'b1010 (Alternating bits)");
        vec = 4'b1010;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: vec = 4'b0101 (Alternating bits inverted)");
        vec = 4'b0101;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: vec = 4'b1100 (High nibble high, Low nibble low)");
        vec = 4'b1100;
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: vec = 4'b0011 (Low nibble high, High nibble low)");
        vec = 4'b0011;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: vec = 4'b1001 (Boundary bits)");
        vec = 4'b1001;
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: vec = 4'b0110 (Middle bits)");
        vec = 4'b0110;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: vec = 4'b1110 (One LSB zero)");
        vec = 4'b1110;
        #1;

        check_outputs(2'b10, 2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: vec = 4'b0001 (Single bit LSB)");
        vec = 4'b0001;
        #1;

        check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_outs;
        input [1:0] expected_outv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outs === (expected_outs ^ outs ^ expected_outs) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: outs=%h, outv=%h",
                         outs, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outs=%h, outv=%h",
                         expected_outs, expected_outv);
                $display("  Got:      outs=%h, outv=%h",
                         outs, outv);
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
