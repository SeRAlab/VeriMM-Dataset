`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg extop;
    reg [15:0] imm;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extop(extop),
        .imm(imm),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero extension (extop=0) with MSB=0", test_num);
            imm = 16'h1234;
            extop = 1'b0;
            #1;

            check_outputs(32'h0000_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero extension (extop=0) with MSB=1", test_num);
            imm = 16'h8ABC;
            extop = 1'b0;
            #1;

            check_outputs(32'h0000_8ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign extension (extop=1) with MSB=0", test_num);
            imm = 16'h7FFF;
            extop = 1'b1;
            #1;

            check_outputs(32'h0000_7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign extension (extop=1) with MSB=1", test_num);
            imm = 16'h8000;
            extop = 1'b1;
            #1;

            check_outputs(32'hFFFF_8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero extension (extop=0) with all ones", test_num);
            imm = 16'hFFFF;
            extop = 1'b0;
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign extension (extop=1) with all ones", test_num);
            imm = 16'hFFFF;
            extop = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign extension (extop=1) with all zeros", test_num);
            imm = 16'h0000;
            extop = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero extension (extop=0) with all zeros", test_num);
            imm = 16'h0000;
            extop = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
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
