`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] sel;
    reg [71:0] x0;
    reg [71:0] x1;
    reg [71:0] x2;
    reg [71:0] x3;
    wire [71:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x0 (sel=00)", test_num);
            x0 = 72'hA5A5A5A5A5A5A5A5A5;
            x1 = 72'h0;
            x2 = 72'h0;
            x3 = 72'h0;
            sel = 2'b00;
            #1;

            check_outputs(72'hA5A5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x1 (sel=01)", test_num);
            x0 = 72'h0;
            x1 = 72'h5A5A5A5A5A5A5A5A5A;
            x2 = 72'h0;
            x3 = 72'h0;
            sel = 2'b01;
            #1;

            check_outputs(72'h5A5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x2 (sel=10)", test_num);
            x0 = 72'h0;
            x1 = 72'h0;
            x2 = 72'h123456789ABCDEF012;
            x3 = 72'h0;
            sel = 2'b10;
            #1;

            check_outputs(72'h123456789ABCDEF012);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x3 (sel=11)", test_num);
            x0 = 72'hFFFFFFFFFFFFFFFFFF;
            x1 = 72'hEEEEEEEEEEEEEEEEEE;
            x2 = 72'hDDDDDDDDDDDDDDDDDD;
            x3 = 72'hCCCCCCCCCCCCCCCCCC;
            sel = 2'b11;
            #1;

            check_outputs(72'hCCCCCCCCCCCCCCCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs identical, check x2", test_num);
            x0 = 72'hFFFFFFFFFFFFFFFFFF;
            x1 = 72'hFFFFFFFFFFFFFFFFFF;
            x2 = 72'hFFFFFFFFFFFFFFFFFF;
            x3 = 72'hFFFFFFFFFFFFFFFFFF;
            sel = 2'b10;
            #1;

            check_outputs(72'hFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case, all zeros, select x1", test_num);
            x0 = 72'hFFFFFFFFFFFFFFFFFF;
            x1 = 72'h000000000000000000;
            x2 = 72'hFFFFFFFFFFFFFFFFFF;
            x3 = 72'hFFFFFFFFFFFFFFFFFF;
            sel = 2'b01;
            #1;

            check_outputs(72'h000000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits on x0", test_num);
            x0 = 72'h112233445566778899;
            x1 = 72'h0;
            x2 = 72'h0;
            x3 = 72'h0;
            sel = 2'b00;
            #1;

            check_outputs(72'h112233445566778899);
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
        input [71:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
