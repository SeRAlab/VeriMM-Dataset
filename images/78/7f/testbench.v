`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] funct;
    reg [31:0] inA;
    reg [31:0] inB;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .funct(funct),
        .inA(inA),
        .inB(inB),
        .out(out),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Bitwise AND", test_num);
        inA = 32'hF0F0_AAAA;
        inB = 32'hFFFF_0000;
        funct = 3'b000;
        #1;

        check_outputs(32'hF0F0_0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Bitwise OR", test_num);
        inA = 32'h1234_0000;
        inB = 32'h0000_5678;
        funct = 3'b001;
        #1;

        check_outputs(32'h1234_5678, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Simple Addition", test_num);
        inA = 32'd100;
        inB = 32'd250;
        funct = 3'b010;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Simple Subtraction", test_num);
        inA = 32'd500;
        inB = 32'd120;
        funct = 3'b011;
        #1;

        check_outputs(32'd380, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Addition Zero Flag", test_num);
        inA = 32'hFFFF_FFFF;
        inB = 32'h0000_0001;
        funct = 3'b010;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Subtraction Zero Flag", test_num);
        inA = 32'hABCDE_123;
        inB = 32'hABCDE_123;
        funct = 3'b011;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: AND Zero Flag", test_num);
        inA = 32'hAAAA_AAAA;
        inB = 32'h5555_5555;
        funct = 3'b000;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Subtraction Negative Result", test_num);
        inA = 32'd10;
        inB = 32'd20;
        funct = 3'b011;
        #1;

        check_outputs(32'hFFFF_FFF6, 1'b0);
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
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
