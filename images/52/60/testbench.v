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
        test_num = 1;
        $display("\nTestcase %03d: Zero Input", test_num);
        i_data0 = 32'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Unit Input", test_num);
        i_data0 = 32'd1;
        #1;

        check_outputs(32'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Simple Positive Value", test_num);
        i_data0 = 32'd10;
        #1;

        check_outputs(32'd120);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Negative Value", test_num);
        i_data0 = -32'd5;
        #1;

        check_outputs(-32'd60);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Large Value", test_num);
        i_data0 = 32'h00010000;
        #1;

        check_outputs(32'h000C0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Max Positive Integer", test_num);
        i_data0 = 32'h7FFFFFFF;

        #1;


        check_outputs(32'hFFFFFFF4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Overflow Truncation", test_num);
        i_data0 = 32'h40000000;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %03d: All Ones Input", test_num);
        i_data0 = 32'hFFFFFFFF;
        #1;

        check_outputs(-32'd12);
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
