`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data0;
    reg data1;
    reg data2;
    reg data3;
    reg sel0;
    reg sel1;
    wire mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel0(sel0),
        .sel1(sel1),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        sel1 = 1'b0; sel0 = 1'b0;
        data0 = 1'b0; data1 = 1'b1; data2 = 1'b1; data3 = 1'b1;
        $display("Test %0d: Select data0, set data0=0 (others=1)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sel1 = 1'b0; sel0 = 1'b0;
        data0 = 1'b1; data1 = 1'b0; data2 = 1'b0; data3 = 1'b0;
        $display("Test %0d: Select data0, set data0=1 (others=0)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sel1 = 1'b0; sel0 = 1'b1;
        data1 = 1'b0; data0 = 1'b1; data2 = 1'b1; data3 = 1'b1;
        $display("Test %0d: Select data1, set data1=0 (others=1)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sel1 = 1'b0; sel0 = 1'b1;
        data1 = 1'b1; data0 = 1'b0; data2 = 1'b0; data3 = 1'b0;
        $display("Test %0d: Select data1, set data1=1 (others=0)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sel1 = 1'b1; sel0 = 1'b0;
        data2 = 1'b0; data0 = 1'b1; data1 = 1'b1; data3 = 1'b1;
        $display("Test %0d: Select data2, set data2=0 (others=1)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sel1 = 1'b1; sel0 = 1'b0;
        data2 = 1'b1; data0 = 1'b0; data1 = 1'b0; data3 = 1'b0;
        $display("Test %0d: Select data2, set data2=1 (others=0)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sel1 = 1'b1; sel0 = 1'b1;
        data3 = 1'b0; data0 = 1'b1; data1 = 1'b1; data2 = 1'b1;
        $display("Test %0d: Select data3, set data3=0 (others=1)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sel1 = 1'b1; sel0 = 1'b1;
        data3 = 1'b1; data0 = 1'b0; data1 = 1'b0; data2 = 1'b0;
        $display("Test %0d: Select data3, set data3=1 (others=0)", test_num);
        #1;

        check_outputs(1'b1);
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
        input expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%b",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%b",
                         expected_mux_out);
                $display("  Got:      mux_out=%b",
                         mux_out);
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
