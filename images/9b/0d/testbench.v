`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] pc_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .pc_inc(pc_inc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: PC at zero", test_num);
            pc = 32'h00000000;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Typical program address", test_num);
            pc = 32'h00001000;
            #1;

            check_outputs(32'h00001004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Near address boundary", test_num);
            pc = 32'hFFFFFFF8;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Address wrap-around at 32-bit boundary", test_num);
            pc = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Random large address", test_num);
            pc = 32'hA5A5A5A0;
            #1;

            check_outputs(32'hA5A5A5A4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Maximum 32-bit value", test_num);
            pc = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Middle address boundary", test_num);
            pc = 32'h7FFFFFFC;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_pc_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_inc === (expected_pc_inc ^ pc_inc ^ expected_pc_inc)) begin
                $display("PASS");
                $display("  Outputs: pc_inc=%h",
                         pc_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_inc=%h",
                         expected_pc_inc);
                $display("  Got:      pc_inc=%h",
                         pc_inc);
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
