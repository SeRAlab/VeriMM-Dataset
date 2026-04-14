`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg done_0a;
    reg go_0r;
    reg reset;
    wire done_0r;
    wire go_0a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .done_0a(done_0a),
        .go_0r(go_0r),
        .reset(reset),
        .done_0r(done_0r),
        .go_0a(go_0a)
    );
    task testcase001;

        begin
            $display("testcase001: Initial state after reset");
            test_num = 1;
            reset = 1;
            go_0r = 0;
            done_0a = 0;
            #20 reset = 0;
            #20;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Initiation handshake (Go phase)");
            test_num = 2;
            reset = 1;
            go_0r = 0;
            done_0a = 0;
            #20 reset = 0;
            #10;
            go_0r = 1;

            wait(go_0a === 1);
            #5;

            #1;


            check_outputs(done_0r, 1);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Full operation cycle (Go to Done)");
            test_num = 3;
            reset = 1;
            go_0r = 0;
            done_0a = 0;
            #20 reset = 0;
            #10;
            go_0r = 1;

            wait(go_0a === 1);

            wait(done_0r === 1);

            #10 done_0a = 1;

            wait(done_0r === 0);
            go_0r = 0;
            done_0a = 0;
            #20;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Reset during active operation");
            test_num = 4;
            reset = 1;
            go_0r = 0;
            done_0a = 0;
            #20 reset = 0;
            #10;
            go_0r = 1;
            wait(go_0a === 1);

            #10 reset = 1;
            #20 reset = 0;
            #10;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Repeated execution cycles");
            test_num = 5;
            reset = 1;
            go_0r = 0;
            done_0a = 0;
            #20 reset = 0;


            #10 go_0r = 1;
            wait(go_0a === 1);
            wait(done_0r === 1);
            #10 done_0a = 1;
            wait(done_0r === 0);
            go_0r = 0;
            done_0a = 0;


            #20 go_0r = 1;
            wait(go_0a === 1);
            wait(done_0r === 1);
            #10 done_0a = 1;
            wait(done_0r === 0);
            go_0r = 0;
            done_0a = 0;

            #20;
            #1;

            check_outputs(0, 0);
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
        input expected_done_0r;
        input expected_go_0a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done_0r === (expected_done_0r ^ done_0r ^ expected_done_0r) &&
                expected_go_0a === (expected_go_0a ^ go_0a ^ expected_go_0a)) begin
                $display("PASS");
                $display("  Outputs: done_0r=%b, go_0a=%b",
                         done_0r, go_0a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_0r=%b, go_0a=%b",
                         expected_done_0r, expected_go_0a);
                $display("  Got:      done_0r=%b, go_0a=%b",
                         done_0r, go_0a);
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
