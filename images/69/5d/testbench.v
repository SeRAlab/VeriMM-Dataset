`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [1:0] sel;
    wire [3:0] result;

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
        .sel(sel),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select data0 (sel=00)", test_num);
        data0 = 4'hA;
        data1 = 4'h5;
        data2 = 4'h3;
        data3 = 4'hC;
        sel   = 2'b00;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select data1 (sel=01)", test_num);
        data0 = 4'hA;
        data1 = 4'h5;
        data2 = 4'h3;
        data3 = 4'hC;
        sel   = 2'b01;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select data2 (sel=10)", test_num);
        data0 = 4'hA;
        data1 = 4'h5;
        data2 = 4'h3;
        data3 = 4'hC;
        sel   = 2'b10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select data3 (sel=11)", test_num);
        data0 = 4'hA;
        data1 = 4'h5;
        data2 = 4'h3;
        data3 = 4'hC;
        sel   = 2'b11;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All inputs identical", test_num);
        data0 = 4'hF;
        data1 = 4'hF;
        data2 = 4'hF;
        data3 = 4'hF;
        sel   = 2'b01;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Check isolation (change unselected input)", test_num);
        data0 = 4'h1;
        data1 = 4'h2;
        data2 = 4'h4;
        data3 = 4'h8;
        sel   = 2'b00;
        #5;
        data1 = 4'hF;
        data2 = 4'hE;
        data3 = 4'hD;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select zero value", test_num);
        data0 = 4'h0;
        data1 = 4'h0;
        data2 = 4'h0;
        data3 = 4'h0;
        sel   = 2'b11;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
