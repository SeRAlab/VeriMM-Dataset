`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] alufun;
    reg [31:0] inst;
    reg [1:0] op2sel;
    reg [4:0] rs1;
    reg [31:0] rs2;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alufun(alufun),
        .inst(inst),
        .op2sel(op2sel),
        .rs1(rs1),
        .rs2(rs2),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (op2sel=0)", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b00;
        rs1    = 5'd10;
        rs2    = 32'd20;

        #1;


        check_outputs(32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Zero", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b00;
        rs1    = 5'd0;
        rs2    = 32'hA5A5A5A5;

        #1;


        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b00;
        rs1    = 5'd31;
        rs2    = 32'hFFFFFFFF;

        #1;


        check_outputs(32'h0000001E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Shift (op2sel=1)", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b01;
        rs1    = 5'd1;
        rs2    = 32'd4;

        #1;


        check_outputs(32'h00000010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Shift (Complex)", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b01;
        rs1    = 5'b10101;
        rs2    = 32'd2;

        #1;


        check_outputs(32'h00000054);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Shift by Zero", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b01;
        rs1    = 5'd15;
        rs2    = 32'd0;

        #1;


        check_outputs(32'h0000000F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Shift to MSB", test_num);
        alufun = 3'b000;
        inst   = 32'h0;
        op2sel = 2'b01;
        rs1    = 5'd1;
        rs2    = 32'd31;

        #1;


        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with non-zero alufun/inst", test_num);
        alufun = 3'b111;
        inst   = 32'hDEADBEEF;
        op2sel = 2'b00;
        rs1    = 5'd5;
        rs2    = 32'd5;

        #1;


        check_outputs(32'h0000000A);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
