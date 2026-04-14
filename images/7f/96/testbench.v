`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [7:0] vref;
    wire isnk;
    wire isrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .vref(vref),
        .isnk(isnk),
        .isrc(isrc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl High, Vref Max", test_num);
            ctrl = 1'b1;
            vref = 8'hFF;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl Low, Vref Max", test_num);
            ctrl = 1'b0;
            vref = 8'hFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl High, Vref Mid", test_num);
            ctrl = 1'b1;
            vref = 8'h80;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl Low, Vref Mid", test_num);
            ctrl = 1'b0;
            vref = 8'h80;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl High, Vref Min Non-Zero", test_num);
            ctrl = 1'b1;
            vref = 8'h01;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl Low, Vref Min Non-Zero", test_num);
            ctrl = 1'b0;
            vref = 8'h01;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl High, Vref Zero", test_num);
            ctrl = 1'b1;
            vref = 8'h00;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Ctrl Low, Vref Zero", test_num);
            ctrl = 1'b0;
            vref = 8'h00;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
            testcase004();
        end
        endtask

    task testcases2;

        begin
            testcase005();
            testcase006();
            testcase007();
            testcase008();
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
        testcases1();
        testcases2();
        
        
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
        input expected_isnk;
        input expected_isrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_isnk === (expected_isnk ^ isnk ^ expected_isnk) &&
                expected_isrc === (expected_isrc ^ isrc ^ expected_isrc)) begin
                $display("PASS");
                $display("  Outputs: isnk=%b, isrc=%b",
                         isnk, isrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isnk=%b, isrc=%b",
                         expected_isnk, expected_isrc);
                $display("  Got:      isnk=%b, isrc=%b",
                         isnk, isrc);
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
