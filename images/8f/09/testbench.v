`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire [3:0] outv;
    wire [1:0] outv1;
    wire [1:0] outv2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .outv(outv),
        .outv1(outv1),
        .outv2(outv2)
    );
    task testcase001;

        begin
            $display("Testcase 001: vec = 4'b0000");
            vec = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 4'b0000, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: vec = 4'b1111");
            vec = 4'b1111;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 4'b1111, 2'b11, 2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: vec = 4'b1010");
            vec = 4'b1010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 4'b1010, 2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: vec = 4'b0101");
            vec = 4'b0101;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 4'b0101, 2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: vec = 4'b1100");
            vec = 4'b1100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 4'b1100, 2'b11, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: vec = 4'b0011");
            vec = 4'b0011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 4'b0011, 2'b00, 2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: vec = 4'b1001");
            vec = 4'b1001;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 4'b1001, 2'b10, 2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: vec = 4'b0110");
            vec = 4'b0110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 4'b0110, 2'b01, 2'b10);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input [3:0] expected_outv;
        input [1:0] expected_outv1;
        input [1:0] expected_outv2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv) &&
                expected_outv1 === (expected_outv1 ^ outv1 ^ expected_outv1) &&
                expected_outv2 === (expected_outv2 ^ outv2 ^ expected_outv2)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h",
                         o0, o1, o2, o3, outv, outv1, outv2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_outv, expected_outv1, expected_outv2);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h",
                         o0, o1, o2, o3, outv, outv1, outv2);
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
