`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cx0;
    reg cx1;
    wire [1:0] bm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cx0(cx0),
        .cx1(cx1),
        .bm(bm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: cx1=0, cx0=0", test_num);
            cx1 = 0;
            cx0 = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: cx1=0, cx0=1", test_num);
            cx1 = 0;
            cx0 = 1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: cx1=1, cx0=0", test_num);
            cx1 = 1;
            cx0 = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: cx1=1, cx0=1", test_num);
            cx1 = 1;
            cx0 = 1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle Sequence", test_num);
            cx1 = 0; cx0 = 0; #5;
            cx1 = 1; cx0 = 1; #5;
            cx1 = 0; cx0 = 1; #5;
            cx1 = 1; cx0 = 0;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_bm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bm === (expected_bm ^ bm ^ expected_bm)) begin
                $display("PASS");
                $display("  Outputs: bm=%h",
                         bm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bm=%h",
                         expected_bm);
                $display("  Got:      bm=%h",
                         bm);
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
