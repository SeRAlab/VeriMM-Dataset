`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] lut_index;
    wire [31:0] lut_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lut_index(lut_index),
        .lut_data(lut_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 0", test_num);
        lut_index = 10'd0;
        #1;

        check_outputs(DATA0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 1", test_num);
        lut_index = 10'd1;
        #1;

        check_outputs(DATA1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 2", test_num);
        lut_index = 10'd2;
        #1;

        check_outputs(DATA2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 3", test_num);
        lut_index = 10'd3;
        #1;

        check_outputs(DATA3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 4", test_num);
        lut_index = 10'd4;
        #1;

        check_outputs(DATA4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 5", test_num);
        lut_index = 10'd5;
        #1;

        check_outputs(DATA5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing boundary index 6 (Default)", test_num);
        lut_index = 10'd6;
        #1;

        check_outputs(DEFAULT_DATA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing index 512 (Default)", test_num);
        lut_index = 10'd512;
        #1;

        check_outputs(DEFAULT_DATA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing maximum index 1023 (Default)", test_num);
        lut_index = 10'd1023;
        #1;

        check_outputs(DEFAULT_DATA);
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
        input [31:0] expected_lut_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lut_data === (expected_lut_data ^ lut_data ^ expected_lut_data)) begin
                $display("PASS");
                $display("  Outputs: lut_data=%h",
                         lut_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lut_data=%h",
                         expected_lut_data);
                $display("  Got:      lut_data=%h",
                         lut_data);
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
