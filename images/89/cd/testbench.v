`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_CTRL;
    reg [15:0] source1;
    reg [15:0] source2;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_CTRL(ALU_CTRL),
        .source1(source1),
        .source2(source2),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition - Basic", test_num);
        ALU_CTRL = 4'b0000;
        source1 = 16'h0005;
        source2 = 16'h0010;
        #1;
        #1;

        check_outputs(16'h0015);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition - Overflow wrap-around", test_num);
        ALU_CTRL = 4'b0000;
        source1 = 16'hFFFF;
        source2 = 16'h0001;
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction - Basic", test_num);
        ALU_CTRL = 4'b0001;
        source1 = 16'h0020;
        source2 = 16'h0005;
        #1;
        #1;

        check_outputs(16'h001B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction - Identity (Zero result)", test_num);
        ALU_CTRL = 4'b0001;
        source1 = 16'hA5A5;
        source2 = 16'hA5A5;
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction - Underflow", test_num);
        ALU_CTRL = 4'b0001;
        source1 = 16'h0000;
        source2 = 16'h0001;
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SLT - True (source1 < source2)", test_num);
        ALU_CTRL = 4'b0010;
        source1 = 16'h0002;
        source2 = 16'h000A;
        #1;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SLT - False (source1 > source2)", test_num);
        ALU_CTRL = 4'b0010;
        source1 = 16'h0010;
        source2 = 16'h0002;
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SLT - False (source1 == source2)", test_num);
        ALU_CTRL = 4'b0010;
        source1 = 16'h7FFF;
        source2 = 16'h7FFF;
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SLT - Unsigned boundary", test_num);
        ALU_CTRL = 4'b0010;
        source1 = 16'h7FFF;
        source2 = 16'h8000;
        #1;
        #1;

        check_outputs(16'h0001);
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
        input [15:0] expected_result;
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
