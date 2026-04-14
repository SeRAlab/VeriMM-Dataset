`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_op;
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] ALU_out;
    wire less;
    wire overflow;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_op(ALU_op),
        .a(a),
        .b(b),
        .ALU_out(ALU_out),
        .less(less),
        .overflow(overflow),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd15; b = 32'd25; ALU_op = 4'd0;
        #1;

        check_outputs(32'd40, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'h7FFFFFFF; b = 32'h00000001; ALU_op = 4'd0;
        #1;

        check_outputs(32'h80000000, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'd50; b = 32'd50; ALU_op = 4'd1;
        #1;

        check_outputs(32'd0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'd10; b = 32'd20; ALU_op = 4'd1;
        #1;

        check_outputs(32'hFFFFFFF6, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hAAAA_AAAA; b = 32'hFFFF_0000; ALU_op = 4'd2;
        #1;

        check_outputs(32'hAAAA_0000, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h1234_0000; b = 32'h0000_5678; ALU_op = 4'd3;
        #1;

        check_outputs(32'h1234_5678, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'hFFFF_FFFF; b = 32'hF0F0_F0F0; ALU_op = 4'd4;
        #1;

        check_outputs(32'h0F0F_0F0F, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'hFFFF_FFFF; b = 32'h0000_0001; ALU_op = 4'd5;
        #1;

        check_outputs(32'h0000_0001, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'd5; b = 32'hFFFF_FFFB; ALU_op = 4'd5;
        #1;

        check_outputs(32'h0000_0000, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'h0000_0001; b = 32'hFFFF_FFFF; ALU_op = 4'd6;
        #1;

        check_outputs(32'h0000_0001, 1'b1, 1'b0, 1'b0);
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
        input [31:0] expected_ALU_out;
        input expected_less;
        input expected_overflow;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out) &&
                expected_less === (expected_less ^ less ^ expected_less) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h, less=%b, overflow=%b, zero=%b",
                         ALU_out, less, overflow, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h, less=%b, overflow=%b, zero=%b",
                         expected_ALU_out, expected_less, expected_overflow, expected_zero);
                $display("  Got:      ALU_out=%h, less=%b, overflow=%b, zero=%b",
                         ALU_out, less, overflow, zero);
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
