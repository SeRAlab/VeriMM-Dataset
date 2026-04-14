`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1_from_rf_i;
    reg [31:0] data2_from_rf_i;
    reg [2:0] func3;
    wire [1:0] cmp_result_from_branch_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1_from_rf_i(data1_from_rf_i),
        .data2_from_rf_i(data2_from_rf_i),
        .func3(func3),
        .cmp_result_from_branch_o(cmp_result_from_branch_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        func3 = 3'b000;
        data1_from_rf_i = 32'd100;
        data2_from_rf_i = 32'd100;
        $display("Testcase %0d: Signed Equality (100 == 100)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        func3 = 3'b000;
        data1_from_rf_i = 32'd50;
        data2_from_rf_i = 32'd100;
        $display("Testcase %0d: Signed Less Than (50 < 100)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        func3 = 3'b000;
        data1_from_rf_i = 32'd150;
        data2_from_rf_i = 32'd100;
        $display("Testcase %0d: Signed Greater Than (150 > 100)", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        func3 = 3'b001;
        data1_from_rf_i = 32'hFFFFFFFF;
        data2_from_rf_i = 32'h00000001;
        $display("Testcase %0d: Signed Comparison (-1 < 1)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        func3 = 3'b110;
        data1_from_rf_i = 32'd200;
        data2_from_rf_i = 32'd200;
        $display("Testcase %0d: Unsigned GE (200 >= 200)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        func3 = 3'b110;
        data1_from_rf_i = 32'd300;
        data2_from_rf_i = 32'd200;
        $display("Testcase %0d: Unsigned GE (300 >= 200)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        func3 = 3'b111;
        data1_from_rf_i = 32'd100;
        data2_from_rf_i = 32'd200;
        $display("Testcase %0d: Unsigned GE (100 >= 200 is False)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        func3 = 3'b110;
        data1_from_rf_i = 32'hFFFFFFFF;
        data2_from_rf_i = 32'h00000001;
        $display("Testcase %0d: Unsigned GE (0xFFFFFFFF >= 1)", test_num);
        #1;

        check_outputs(2'b01);
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
        input [1:0] expected_cmp_result_from_branch_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cmp_result_from_branch_o === (expected_cmp_result_from_branch_o ^ cmp_result_from_branch_o ^ expected_cmp_result_from_branch_o)) begin
                $display("PASS");
                $display("  Outputs: cmp_result_from_branch_o=%h",
                         cmp_result_from_branch_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmp_result_from_branch_o=%h",
                         expected_cmp_result_from_branch_o);
                $display("  Got:      cmp_result_from_branch_o=%h",
                         cmp_result_from_branch_o);
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
