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
            $display("Testcase %0d: Zero multiplication (0 * 0)", test_num);
            i_data0 = {16'h0000, 16'h0000};
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unit multiplication (1 * 1)", test_num);
            i_data0 = {16'h0001, 16'h0001};
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple multiplication (10 * 5)", test_num);
            i_data0 = {16'd10, 16'd5};
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (256 * 256)", test_num);
            i_data0 = {16'd256, 16'd256};
            #1;

            check_outputs(32'd65536);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max operand by 1 (65535 * 1)", test_num);
            i_data0 = {16'hFFFF, 16'h0001};
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max operands (65535 * 65535)", test_num);
            i_data0 = {16'hFFFF, 16'hFFFF};
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (0xAAAA * 0x5555)", test_num);
            i_data0 = {16'hAAAA, 16'h5555};
            #1;

            check_outputs(32'h38E31C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small and Large (2 * 16384)", test_num);
            i_data0 = {16'd2, 16'd16384};
            #1;

            check_outputs(32'd32768);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime-like numbers (123 * 456)", test_num);
            i_data0 = {16'd123, 16'd456};
            #1;

            check_outputs(32'd56088);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check (0x8000 * 0x0002)", test_num);
            i_data0 = {16'h8000, 16'h0002};
            #1;

            check_outputs(32'h00010000);
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
