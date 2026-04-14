`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0_i;
    reg [7:0] data1_i;
    reg mask_i;
    wire [7:0] result_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_i(data0_i),
        .data1_i(data1_i),
        .mask_i(mask_i),
        .result_o(result_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=0, selecting data0", test_num);
            mask_i  = 1'b0;
            data0_i = 8'hAA;
            data1_i = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=1, selecting data1", test_num);
            mask_i  = 1'b1;
            data0_i = 8'hAA;
            data1_i = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=0, data0 is FF", test_num);
            mask_i  = 1'b0;
            data0_i = 8'hFF;
            data1_i = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=1, data1 is FF", test_num);
            mask_i  = 1'b1;
            data0_i = 8'h00;
            data1_i = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=0, data0 is 12", test_num);
            mask_i  = 1'b0;
            data0_i = 8'h12;
            data1_i = 8'h34;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: mask_i=1, data1 is CD", test_num);
            mask_i  = 1'b1;
            data0_i = 8'hAB;
            data1_i = 8'hCD;
            #1;

            check_outputs(8'hCD);
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
        input [7:0] expected_result_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_o === (expected_result_o ^ result_o ^ expected_result_o)) begin
                $display("PASS");
                $display("  Outputs: result_o=%h",
                         result_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_o=%h",
                         expected_result_o);
                $display("  Got:      result_o=%h",
                         result_o);
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
