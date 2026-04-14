`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg _reset;
    reg d;
    reg enable;
    wire _q;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._reset(_reset),
        .d(d),
        .enable(enable),
        ._q(_q),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Assertion", test_num);

            _reset = 0;
            enable = 1;
            d = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transparent Mode - Capture Data 1", test_num);

            _reset = 0; #5;
            _reset = 1;
            enable = 1;
            d = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transparent Mode - Capture Data 0", test_num);

            _reset = 0; #5;
            _reset = 1;
            enable = 1;
            d = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Latch Mode - Hold Data 1", test_num);

            _reset = 0; #5;
            _reset = 1;

            enable = 1; d = 1; #5;

            enable = 0; #5;
            d = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Latch Mode - Hold Data 0", test_num);

            _reset = 0; #5;
            _reset = 1;

            enable = 1; d = 0; #5;

            enable = 0; #5;
            d = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous Reset Overriding Enable", test_num);

            _reset = 0; #5;
            _reset = 1;

            enable = 1; d = 1; #5;

            _reset = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Stability in Latch Mode", test_num);

            _reset = 0; #5;
            _reset = 1;

            enable = 1; d = 1; #5;

            enable = 0; #5;

            d = 0; #2; d = 1; #2; d = 0; #2; d = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected__q;
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected__q === (expected__q ^ _q ^ expected__q) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: _q=%b, q=%b",
                         _q, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _q=%b, q=%b",
                         expected__q, expected_q);
                $display("  Got:      _q=%b, q=%b",
                         _q, q);
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
