`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUOp;
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] Result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .a(a),
        .b(b),
        .Result(Result),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        ALUOp = 4'b0000;
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'hFFFF_0000_FFFF_0000;

        #1;


        check_outputs(64'hAAAA_0000_AAAA_0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND (Zero result)", test_num);
        ALUOp = 4'b0000;
        a = 64'h5555_5555_5555_5555;
        b = 64'hAAAA_AAAA_AAAA_AAAA;

        #1;


        check_outputs(64'h0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        ALUOp = 4'b0001;
        a = 64'h1234_5678_0000_0000;
        b = 64'h0000_0000_8765_4321;

        #1;


        check_outputs(64'h1234_5678_8765_4321, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Simple)", test_num);
        ALUOp = 4'b0010;
        a = 64'd1000;
        b = 64'd2000;

        #1;


        check_outputs(64'd3000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Wrap-around)", test_num);
        ALUOp = 4'b0010;
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0000_0000_0000_0001;

        #1;


        check_outputs(64'h0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Positive result)", test_num);
        ALUOp = 4'b0110;
        a = 64'd500;
        b = 64'd100;

        #1;


        check_outputs(64'd400, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Zero flag check)", test_num);
        ALUOp = 4'b0110;
        a = 64'hFEDC_BA98_7654_3210;
        b = 64'hFEDC_BA98_7654_3210;

        #1;


        check_outputs(64'h0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Negative result)", test_num);
        ALUOp = 4'b0110;
        a = 64'd0;
        b = 64'd1;

        #1;


        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR (All ones result)", test_num);
        ALUOp = 4'b1100;
        a = 64'h0;
        b = 64'h0;

        #1;


        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR (Zero result)", test_num);
        ALUOp = 4'b1100;
        a = 64'hFFFF_FFFF_0000_0000;
        b = 64'h0000_0000_FFFF_FFFF;

        #1;


        check_outputs(64'h0000_0000_0000_0000, 1'b1);
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
        input [63:0] expected_Result;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Result=%h, Zero=%b",
                         Result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h, Zero=%b",
                         expected_Result, expected_Zero);
                $display("  Got:      Result=%h, Zero=%b",
                         Result, Zero);
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
