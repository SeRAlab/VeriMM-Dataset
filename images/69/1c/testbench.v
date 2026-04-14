`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg [31:0] read1;
    reg [31:0] read2;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .read1(read1),
        .read2(read2),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical AND", test_num);
        read1   = 32'hF0F0_FFFF;
        read2   = 32'h0F0F_FFFF;
        control = OP_AND;
        #1;

        check_outputs(32'h0000_FFFF, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical OR", test_num);
        read1   = 32'hAAAA_0000;
        read2   = 32'h0000_5555;
        control = OP_OR;
        #1;

        check_outputs(32'hAAAA_5555, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arithmetic ADD (100 + 250)", test_num);
        read1   = 32'd100;
        read2   = 32'd250;
        control = OP_ADD;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arithmetic SUB (500 - 100)", test_num);
        read1   = 32'd500;
        read2   = 32'd100;
        control = OP_SUB;
        #1;

        check_outputs(32'd400, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arithmetic SUB Result Zero", test_num);
        read1   = 32'h1234_5678;
        read2   = 32'h1234_5678;
        control = OP_SUB;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SLT (10 < 20)", test_num);
        read1   = 32'd10;
        read2   = 32'd20;
        control = OP_SLT;
        #1;

        check_outputs(32'd1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SLT (20 < 10)", test_num);
        read1   = 32'd20;
        read2   = 32'd10;
        control = OP_SLT;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical NOR", test_num);
        read1   = 32'h0000_0000;
        read2   = 32'h0000_0000;
        control = OP_NOR;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arithmetic ADD (-1 + 1)", test_num);
        read1   = 32'hFFFF_FFFF;
        read2   = 32'h0000_0001;
        control = OP_ADD;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SLT Signed (-5 < 2)", test_num);
        read1   = 32'hFFFF_FFFB;
        read2   = 32'h0000_0002;
        control = OP_SLT;
        #1;

        check_outputs(32'd1, 1'b0);
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
