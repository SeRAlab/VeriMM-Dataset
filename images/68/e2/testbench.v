`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] data0_i;
    reg [1:0] data1_i;
    reg [1:0] data2_i;
    reg [1:0] select_i;
    wire [1:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_i(data0_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .select_i(select_i),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select data0_i", test_num);
        data0_i = 2'b11;
        data1_i = 2'b00;
        data2_i = 2'b01;
        select_i = 2'b00;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select data1_i", test_num);
        data0_i = 2'b11;
        data1_i = 2'b10;
        data2_i = 2'b01;
        select_i = 2'b01;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select data2_i", test_num);
        data0_i = 2'b11;
        data1_i = 2'b10;
        data2_i = 2'b01;
        select_i = 2'b10;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Change values and select data0_i", test_num);
        data0_i = 2'b01;
        data1_i = 2'b11;
        data2_i = 2'b10;
        select_i = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Change values and select data1_i", test_num);
        data0_i = 2'b01;
        data1_i = 2'b11;
        data2_i = 2'b10;
        select_i = 2'b01;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Change values and select data2_i", test_num);
        data0_i = 2'b01;
        data1_i = 2'b11;
        data2_i = 2'b10;
        select_i = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All inputs zero", test_num);
        data0_i = 2'b00;
        data1_i = 2'b00;
        data2_i = 2'b00;
        select_i = 2'b01;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
