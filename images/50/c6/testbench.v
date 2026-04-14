`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire q;
    wire qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .s(s),
        .q(q),
        .qn(qn)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Set State (s=0, r=1)", test_num);

            s = 1; r = 0; #10;

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Reset State (s=1, r=0)", test_num);

            s = 0; r = 1; #10;

            s = 1; r = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hold State after Set (s=1, r=1)", test_num);

            s = 0; r = 1; #10;

            s = 1; r = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hold State after Reset (s=1, r=1)", test_num);

            s = 1; r = 0; #10;

            s = 1; r = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Both Inputs Low (s=0, r=0)", test_num);

            s = 0; r = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset after Invalid state (s=0,r=0 -> s=1,r=0)", test_num);

            s = 0; r = 0; #10;

            s = 1; r = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Set after Invalid state (s=0,r=0 -> s=0,r=1)", test_num);

            s = 0; r = 0; #10;

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_q;
        input expected_qn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qn === (expected_qn ^ qn ^ expected_qn)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qn=%b",
                         q, qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qn=%b",
                         expected_q, expected_qn);
                $display("  Got:      q=%b, qn=%b",
                         q, qn);
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
