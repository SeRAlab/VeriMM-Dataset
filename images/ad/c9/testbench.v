`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg data;
    wire q;
    wire qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .q(q),
        .qbar(qbar)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transparent Mode - Data=1", test_num);

            clock = 1;
            data = 0;
            #10;

            data = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transparent Mode - Data=0", test_num);

            clock = 1;
            data = 1;
            #10;

            data = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold Mode - Store 1", test_num);

            clock = 1;
            data = 1;
            #10;

            clock = 0;
            #10;

            data = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold Mode - Store 0", test_num);

            clock = 1;
            data = 0;
            #10;

            clock = 0;
            #10;

            data = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold Mode Stability", test_num);

            clock = 1;
            data = 1;
            #10;

            clock = 0;
            #10;

            data = 0; #5;
            data = 1; #5;
            data = 0; #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Recover Transparency", test_num);

            clock = 1; data = 1; #10;
            clock = 0; data = 0; #10;

            clock = 1;
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
        input expected_qbar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qbar=%b",
                         q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qbar=%b",
                         expected_q, expected_qbar);
                $display("  Got:      q=%b, qbar=%b",
                         q, qbar);
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
