`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] _num;
    wire [3:0] _hundreds;
    wire [3:0] _ones;
    wire [3:0] _tens;
    wire [3:0] _thousands;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._num(_num),
        ._hundreds(_hundreds),
        ._ones(_ones),
        ._tens(_tens),
        ._thousands(_thousands)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0", test_num);
            _num = 12'd0;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1234", test_num);
            _num = 12'd1234;
            #1;

            check_outputs(4'd2, 4'd4, 4'd3, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4095 (Max 12-bit)", test_num);
            _num = 12'd4095;
            #1;

            check_outputs(4'd0, 4'd5, 4'd9, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5", test_num);
            _num = 12'd5;
            #1;

            check_outputs(4'd0, 4'd5, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 56", test_num);
            _num = 12'd56;
            #1;

            check_outputs(4'd0, 4'd6, 4'd5, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 789", test_num);
            _num = 12'd789;
            #1;

            check_outputs(4'd7, 4'd9, 4'd8, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1000", test_num);
            _num = 12'd1000;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2048", test_num);
            _num = 12'd2048;
            #1;

            check_outputs(4'd0, 4'd8, 4'd4, 4'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 3999", test_num);
            _num = 12'd3999;
            #1;

            check_outputs(4'd9, 4'd9, 4'd9, 4'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 102", test_num);
            _num = 12'd102;
            #1;

            check_outputs(4'd1, 4'd2, 4'd0, 4'd0);
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
        input [3:0] expected__hundreds;
        input [3:0] expected__ones;
        input [3:0] expected__tens;
        input [3:0] expected__thousands;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected__hundreds === (expected__hundreds ^ _hundreds ^ expected__hundreds) &&
                expected__ones === (expected__ones ^ _ones ^ expected__ones) &&
                expected__tens === (expected__tens ^ _tens ^ expected__tens) &&
                expected__thousands === (expected__thousands ^ _thousands ^ expected__thousands)) begin
                $display("PASS");
                $display("  Outputs: _hundreds=%h, _ones=%h, _tens=%h, _thousands=%h",
                         _hundreds, _ones, _tens, _thousands);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _hundreds=%h, _ones=%h, _tens=%h, _thousands=%h",
                         expected__hundreds, expected__ones, expected__tens, expected__thousands);
                $display("  Got:      _hundreds=%h, _ones=%h, _tens=%h, _thousands=%h",
                         _hundreds, _ones, _tens, _thousands);
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
