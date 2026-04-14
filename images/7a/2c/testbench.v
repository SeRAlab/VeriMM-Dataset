`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] data0x;
    reg [21:0] data1x;
    reg [21:0] data2x;
    reg [1:0] sel;
    wire [21:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0x(data0x),
        .data1x(data1x),
        .data2x(data2x),
        .sel(sel),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select data0x (sel=00)", test_num);
        data0x = 22'h123456;
        data1x = 22'h2AAAAA;
        data2x = 22'h3FFFFF;
        sel = 2'b00;
        #1;

        check_outputs(22'h123456);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select data1x (sel=01)", test_num);
        data0x = 22'h123456;
        data1x = 22'h2AAAAA;
        data2x = 22'h3FFFFF;
        sel = 2'b01;
        #1;

        check_outputs(22'h2AAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select data2x (sel=10)", test_num);
        data0x = 22'h123456;
        data1x = 22'h2AAAAA;
        data2x = 22'h3FFFFF;
        sel = 2'b10;
        #1;

        check_outputs(22'h3FFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All zeros check on data0x", test_num);
        data0x = 22'h000000;
        data1x = 22'h3FFFFF;
        data2x = 22'h3FFFFF;
        sel = 2'b00;
        #1;

        check_outputs(22'h000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All ones check on data1x", test_num);
        data0x = 22'h000000;
        data1x = 22'h3FFFFF;
        data2x = 22'h000000;
        sel = 2'b01;
        #1;

        check_outputs(22'h3FFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating bits check on data2x", test_num);
        data0x = 22'h000000;
        data1x = 22'h000000;
        data2x = 22'h155555;
        sel = 2'b10;
        #1;

        check_outputs(22'h155555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Invalid selection (sel=11)", test_num);
        data0x = 22'h111111;
        data1x = 22'h222222;
        data2x = 22'h333333;
        sel = 2'b11;

        #1;


        check_outputs(22'bxxxxxxxxxxxxxxxxxxxxxx);
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
        input [21:0] expected_result;
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
