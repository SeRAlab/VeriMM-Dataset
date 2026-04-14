`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] shamt_i;
    reg [31:0] src_i;
    wire [31:0] shifter_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .shamt_i(shamt_i),
        .src_i(src_i),
        .shifter_o(shifter_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive value, shift 0", test_num);
            src_i = 32'h12345678;
            shamt_i = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive value, shift 4", test_num);
            src_i = 32'h0F000000;
            shamt_i = 5'd4;
            #1;

            check_outputs(32'h00F00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative value, shift 4 (sign extension)", test_num);
            src_i = 32'hF0000000;
            shamt_i = 5'd4;
            #1;

            check_outputs(32'hFF000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum shift amount (31) for positive", test_num);
            src_i = 32'h7FFFFFFF;
            shamt_i = 5'd31;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum shift amount (31) for negative", test_num);
            src_i = 32'h80000000;
            shamt_i = 5'd31;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift -1 (all ones)", test_num);
            src_i = 32'hFFFFFFFF;
            shamt_i = 5'd16;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift zero value", test_num);
            src_i = 32'h00000000;
            shamt_i = 5'd10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range negative shift", test_num);
            src_i = 32'hAAAA5555;
            shamt_i = 5'd8;

            #1;


            check_outputs(32'hFFAAAA55);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range positive shift", test_num);
            src_i = 32'h5555AAAA;
            shamt_i = 5'd8;

            #1;


            check_outputs(32'h005555AA);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit shift negative", test_num);
            src_i = 32'h80000000;
            shamt_i = 5'd1;
            #1;

            check_outputs(32'hC0000000);
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
        input [31:0] expected_shifter_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifter_o === (expected_shifter_o ^ shifter_o ^ expected_shifter_o)) begin
                $display("PASS");
                $display("  Outputs: shifter_o=%h",
                         shifter_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifter_o=%h",
                         expected_shifter_o);
                $display("  Got:      shifter_o=%h",
                         shifter_o);
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
