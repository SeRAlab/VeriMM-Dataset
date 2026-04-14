`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] f;
    reg [31:0] op1;
    reg [31:0] op2;
    wire [31:0] result_hi;
    wire [31:0] result_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .f(f),
        .op1(op1),
        .op2(op2),
        .result_hi(result_hi),
        .result_lo(result_lo)
    );
    task testcase001;

    begin
        test_num = 1;
        en = 1; f = 4'b0000; op1 = 32'd10; op2 = 32'd3;
        $display("Testcase %0d: Signed Div (10 / 3)", test_num);
        #1;

        check_outputs(32'd1, 32'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        en = 1; f = 4'b0000; op1 = -32'd10; op2 = 32'd3;
        $display("Testcase %0d: Signed Div (-10 / 3)", test_num);
        #1;

        check_outputs(-32'd1, -32'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        en = 1; f = 4'b0000; op1 = 32'd10; op2 = -32'd3;
        $display("Testcase %0d: Signed Div (10 / -3)", test_num);
        #1;

        check_outputs(32'd1, -32'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        en = 1; f = 4'b0001; op1 = 32'hFFFFFFFF; op2 = 32'd2;
        $display("Testcase %0d: Unsigned Div (0xFFFFFFFF / 2)", test_num);
        #1;

        check_outputs(32'h00000001, 32'h7FFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        en = 1; f = 4'b0010; op1 = 32'd5; op2 = 32'd10;
        $display("Testcase %0d: Signed Mult (5 * 10)", test_num);
        #1;

        check_outputs(32'd0, 32'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        en = 1; f = 4'b0010; op1 = -32'd5; op2 = 32'd10;
        $display("Testcase %0d: Signed Mult (-5 * 10)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFCE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        en = 1; f = 4'b0010; op1 = 32'h40000000; op2 = 32'd4;
        $display("Testcase %0d: Signed Mult (0x40000000 * 4)", test_num);
        #1;

        check_outputs(32'h00000001, 32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        en = 1; f = 4'b0011; op1 = 32'hFFFFFFFF; op2 = 32'hFFFFFFFF;
        $display("Testcase %0d: Unsigned Mult (Max * Max)", test_num);
        #1;

        check_outputs(32'hFFFFFFFE, 32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        en = 1; f = 4'b0011; op1 = 32'd100; op2 = 32'd200;
        $display("Testcase %0d: Unsigned Mult (100 * 200) with en=1", test_num);
        #1;

        check_outputs(32'd0, 32'd20000);
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
        input [31:0] expected_result_hi;
        input [31:0] expected_result_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_hi === (expected_result_hi ^ result_hi ^ expected_result_hi) &&
                expected_result_lo === (expected_result_lo ^ result_lo ^ expected_result_lo)) begin
                $display("PASS");
                $display("  Outputs: result_hi=%h, result_lo=%h",
                         result_hi, result_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_hi=%h, result_lo=%h",
                         expected_result_hi, expected_result_lo);
                $display("  Got:      result_hi=%h, result_lo=%h",
                         result_hi, result_lo);
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
