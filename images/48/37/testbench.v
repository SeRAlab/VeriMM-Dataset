`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg num;
    reg on;
    wire on_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .on(on),
        .on_out(on_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset - on=0, num=0", test_num);
            on = 0;
            num = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num=1 while on=0", test_num);
            on = 0;
            num = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Access enabled (on=1) but num=0", test_num);
            on = 0;
            #5;
            on = 1;
            num = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Grant access (on=1, num=1)", test_num);
            on = 0;
            #5;
            on = 1;
            num = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain access state (on=1, num 1->0)", test_num);
            on = 0;
            #5;
            on = 1;
            num = 1;
            #10;
            num = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Revoke access via 'on' reset", test_num);
            on = 0;
            #5;
            on = 1;
            num = 1;
            #10;
            on = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-authentication cycle", test_num);
            on = 0; #5;
            on = 1; num = 1; #5;
            on = 0; #5;
            on = 1; num = 0; #5;
            num = 1; #10;
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
        input expected_on_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_on_out === (expected_on_out ^ on_out ^ expected_on_out)) begin
                $display("PASS");
                $display("  Outputs: on_out=%b",
                         on_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: on_out=%b",
                         expected_on_out);
                $display("  Got:      on_out=%b",
                         on_out);
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
