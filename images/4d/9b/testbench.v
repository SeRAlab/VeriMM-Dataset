`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] oper;
    reg [4:0] shift;
    reg [31:0] srcA;
    reg [31:0] srcB;
    wire [31:0] result;
    wire sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .oper(oper),
        .shift(shift),
        .srcA(srcA),
        .srcB(srcB),
        .result(result),
        .sign(sign)
    );
    task testcase001;

    begin
        test_num = 1;
        oper  = 4'd0;
        srcA  = 32'h0000_0005;
        srcB  = 32'h0000_000A;
        shift = 5'd0;
        #1;

        check_outputs(32'h0000_000F, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        oper  = 4'd1;
        srcA  = 32'hF0F0_AAAA;
        srcB  = 32'h0F0F_5555;
        shift = 5'd0;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        oper  = 4'd2;
        srcA  = 32'hF0F0_F0F0;
        srcB  = 32'hFFFF_0000;
        shift = 5'd0;
        #1;

        check_outputs(32'hF0F0_0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        oper  = 4'd3;
        srcA  = 32'h0000_0001;
        srcB  = 32'h0000_0000;
        shift = 5'd4;
        #1;

        check_outputs(32'h0000_0010, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        oper  = 4'd4;
        srcA  = 32'h8000_0000;
        srcB  = 32'h0000_0000;
        shift = 5'd1;
        #1;

        check_outputs(32'h4000_0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        oper  = 4'd5;
        srcA  = 32'h0000_0014;
        srcB  = 32'h0000_000A;
        shift = 5'd0;
        #1;

        check_outputs(32'h0000_0001, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        oper  = 4'd6;
        srcA  = 32'h0000_0064;
        srcB  = 32'h0000_0001;
        shift = 5'd0;
        #1;

        check_outputs(32'h0000_0063, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        oper  = 4'd6;
        srcA  = 32'h0000_0001;
        srcB  = 32'h0000_0002;
        shift = 5'd0;

        #1;


        check_outputs(32'hFFFF_FFFF, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        oper  = 4'd7;
        srcA  = 32'hAAAAAAAA;
        srcB  = 32'h0000_0000;
        shift = 5'd0;
        #1;

        check_outputs(32'h5555_5555, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        oper  = 4'd8;
        srcA  = 32'h0000_FFFF;
        srcB  = 32'h0000_FFFF;
        shift = 5'd0;
        #1;

        check_outputs(32'h0000_0001, 1'b0);
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
        input [31:0] expected_result;
        input expected_sign;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign)) begin
                $display("PASS");
                $display("  Outputs: result=%h, sign=%b",
                         result, sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, sign=%b",
                         expected_result, expected_sign);
                $display("  Got:      result=%h, sign=%b",
                         result, sign);
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
