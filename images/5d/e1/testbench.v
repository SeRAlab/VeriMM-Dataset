`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data0;
    wire [31:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h00000000;
            #1;

            check_outputs(32'h00000000 * REF_MULT);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h00000001;
            #1;

            check_outputs(32'h00000001 * REF_MULT);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i_data0 = 32'd5;
            #1;

            check_outputs(32'd5 * REF_MULT);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i_data0 = 32'd123;
            #1;

            check_outputs(32'd123 * REF_MULT);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h0000FFFF;
            #1;

            check_outputs(32'h0000FFFF * REF_MULT);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h7FFFFFFF * REF_MULT);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h80000000;
            #1;

            check_outputs(32'h80000000 * REF_MULT);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i_data0 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF * REF_MULT);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            i_data0 = 32'h12345678;
            #1;

            check_outputs(32'h12345678 * REF_MULT);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            i_data0 = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAA * REF_MULT);
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
        input [31:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
