`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALU_CTL;
    reg CLK;
    reg [31:0] NUM1;
    reg [31:0] NUM2;
    wire [31:0] ALU_RES;
    wire ZERO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_CTL(ALU_CTL),
        .CLK(CLK),
        .NUM1(NUM1),
        .NUM2(NUM2),
        .ALU_RES(ALU_RES),
        .ZERO(ZERO)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
        NUM1 = 32'd10;
        NUM2 = 32'd20;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero Result (0 + 0)", test_num);
        NUM1 = 32'd0;
        NUM2 = 32'd0;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Overflow to Zero (0xFFFFFFFF + 1)", test_num);
        NUM1 = 32'hFFFFFFFF;
        NUM2 = 32'd1;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Large Values Addition", test_num);
        NUM1 = 32'h12345678;
        NUM2 = 32'h87654321;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h99999999, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max Unsigned Addition (Wrap around)", test_num);
        NUM1 = 32'hFFFFFFFF;
        NUM2 = 32'hFFFFFFFF;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'hFFFFFFFE, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating Bits Addition", test_num);
        NUM1 = 32'hAAAAAAAA;
        NUM2 = 32'h55555555;
        ALU_CTL = 1'b0;
        CLK = 0;
        #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
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
        input [31:0] expected_ALU_RES;
        input expected_ZERO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_RES === (expected_ALU_RES ^ ALU_RES ^ expected_ALU_RES) &&
                expected_ZERO === (expected_ZERO ^ ZERO ^ expected_ZERO)) begin
                $display("PASS");
                $display("  Outputs: ALU_RES=%h, ZERO=%b",
                         ALU_RES, ZERO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_RES=%h, ZERO=%b",
                         expected_ALU_RES, expected_ZERO);
                $display("  Got:      ALU_RES=%h, ZERO=%b",
                         ALU_RES, ZERO);
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
