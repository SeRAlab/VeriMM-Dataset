`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctr;
    reg [15:0] i_16;
    wire [31:0] o_32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctr(ctr),
        .i_16(i_16),
        .o_32(o_32)
    );
    task testcase001;

        begin
            test_num = 1;
            ctr = 0;
            i_16 = 16'h0005;
            $display("Testcase %0d: ctr=0, positive i_16", test_num);
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ctr = 0;
            i_16 = 16'h8005;
            $display("Testcase %0d: ctr=0, negative i_16", test_num);
            #1;

            check_outputs(32'h00008005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ctr = 1;
            i_16 = 16'h000A;
            $display("Testcase %0d: ctr=1, positive i_16", test_num);
            #1;

            check_outputs(32'h0000000A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ctr = 1;
            i_16 = 16'hFFFF;
            $display("Testcase %0d: ctr=1, negative i_16 (sign extension)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ctr = 1;
            i_16 = 16'h8000;
            $display("Testcase %0d: ctr=1, boundary negative i_16", test_num);
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ctr = 1;
            i_16 = 16'h7FFF;
            $display("Testcase %0d: ctr=1, boundary positive i_16", test_num);
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ctr = 0;
            i_16 = 16'hFFFF;
            $display("Testcase %0d: ctr=0, negative i_16 (should not sign extend)", test_num);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ctr = 1;
            i_16 = 16'h0000;
            $display("Testcase %0d: ctr=1, zero input", test_num);
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_o_32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_32 === (expected_o_32 ^ o_32 ^ expected_o_32)) begin
                $display("PASS");
                $display("  Outputs: o_32=%h",
                         o_32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_32=%h",
                         expected_o_32);
                $display("  Got:      o_32=%h",
                         o_32);
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
