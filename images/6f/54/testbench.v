`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_result;
    reg [31:0] dm_data;
    reg [5:0] op;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_result(alu_result),
        .dm_data(dm_data),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=16 (dm_data direct)", test_num);
            op = 6'd16;
            alu_result = 32'hAAAA_BBBB;
            dm_data = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=18 (SE 16-bit positive)", test_num);
            op = 6'd18;
            alu_result = 32'h0;
            dm_data = 32'hAAAA_7FFF;
            #1;

            check_outputs(32'h0000_7FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=18 (SE 16-bit negative)", test_num);
            op = 6'd18;
            alu_result = 32'h0;
            dm_data = 32'h0000_8001;
            #1;

            check_outputs(32'hFFFF_8001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=20 (SE 8-bit positive)", test_num);
            op = 6'd20;
            alu_result = 32'h1111_1111;
            dm_data = 32'hFFFF_FF7F;
            #1;

            check_outputs(32'h0000_007F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=20 (SE 8-bit negative)", test_num);
            op = 6'd20;
            alu_result = 32'h0;
            dm_data = 32'h0000_00F0;
            #1;

            check_outputs(32'hFFFF_FFF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Default op=0 (alu_result)", test_num);
            op = 6'd0;
            alu_result = 32'hDEAD_BEEF;
            dm_data = 32'h1234_5678;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Default op=31 (alu_result)", test_num);
            op = 6'd31;
            alu_result = 32'hCAFE_BABE;
            dm_data = 32'h0;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: op=17 (alu_result edge case)", test_num);
            op = 6'd17;
            alu_result = 32'h5555_AAAA;
            dm_data = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h5555_AAAA);
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
