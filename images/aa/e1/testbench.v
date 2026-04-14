`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg GO;
    reg [7:0] port_003da58c_;
    reg [7:0] port_019a462a_;
    wire DONE;
    wire [15:0] RESULT;
    wire [7:0] RESULT_u14;
    wire RESULT_u15;
    wire RESULT_u16;
    wire RESULT_u17;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .GO(GO),
        .port_003da58c_(port_003da58c_),
        .port_019a462a_(port_019a462a_),
        .DONE(DONE),
        .RESULT(RESULT),
        .RESULT_u14(RESULT_u14),
        .RESULT_u15(RESULT_u15),
        .RESULT_u16(RESULT_u16),
        .RESULT_u17(RESULT_u17)
    );
    task reset_inputs;

        begin
            GO = 0;
            port_003da58c_ = 8'h0;
            port_019a462a_ = 8'h0;
            @(posedge CLK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Simple Addition (10 + 20)");
            reset_inputs();
            port_003da58c_ = 8'd10;
            port_019a462a_ = 8'd20;
            GO = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 16'd30, 8'd30, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Addition with Carry (200 + 100)");
            reset_inputs();
            port_003da58c_ = 8'd200;
            port_019a462a_ = 8'd100;
            GO = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 16'd300, 8'h2C, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Maximum 8-bit Addition (255 + 255)");
            reset_inputs();
            port_003da58c_ = 8'hFF;
            port_019a462a_ = 8'hFF;
            GO = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 16'd510, 8'hFE, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Zero Addition (0 + 0)");
            reset_inputs();
            port_003da58c_ = 8'h00;
            port_019a462a_ = 8'h00;
            GO = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 16'd0, 8'h00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Power of Two Sum (128 + 128)");
            reset_inputs();
            port_003da58c_ = 8'd128;
            port_019a462a_ = 8'd128;
            GO = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 16'd256, 8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: GO Signal De-asserted");
            reset_inputs();
            port_003da58c_ = 8'd50;
            port_019a462a_ = 8'd50;
            GO = 0;
            @(posedge CLK);
            #1;

            if (DONE === 1'b0) begin
                $display("PASS: DONE is low as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: DONE should be low when GO is 0");
                fail_count = fail_count + 1;
            end
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
        input expected_DONE;
        input [15:0] expected_RESULT;
        input [7:0] expected_RESULT_u14;
        input expected_RESULT_u15;
        input expected_RESULT_u16;
        input expected_RESULT_u17;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DONE === (expected_DONE ^ DONE ^ expected_DONE) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT) &&
                expected_RESULT_u14 === (expected_RESULT_u14 ^ RESULT_u14 ^ expected_RESULT_u14) &&
                expected_RESULT_u15 === (expected_RESULT_u15 ^ RESULT_u15 ^ expected_RESULT_u15) &&
                expected_RESULT_u16 === (expected_RESULT_u16 ^ RESULT_u16 ^ expected_RESULT_u16) &&
                expected_RESULT_u17 === (expected_RESULT_u17 ^ RESULT_u17 ^ expected_RESULT_u17)) begin
                $display("PASS");
                $display("  Outputs: DONE=%b, RESULT=%h, RESULT_u14=%h, RESULT_u15=%b, RESULT_u16=%b, RESULT_u17=%b",
                         DONE, RESULT, RESULT_u14, RESULT_u15, RESULT_u16, RESULT_u17);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DONE=%b, RESULT=%h, RESULT_u14=%h, RESULT_u15=%b, RESULT_u16=%b, RESULT_u17=%b",
                         expected_DONE, expected_RESULT, expected_RESULT_u14, expected_RESULT_u15, expected_RESULT_u16, expected_RESULT_u17);
                $display("  Got:      DONE=%b, RESULT=%h, RESULT_u14=%h, RESULT_u15=%b, RESULT_u16=%b, RESULT_u17=%b",
                         DONE, RESULT, RESULT_u14, RESULT_u15, RESULT_u16, RESULT_u17);
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
