`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg reset;
    reg set;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .set(set),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset - Setting reset=1, set=0", test_num);

            reset = 1;
            set = 0;
            #10;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Set Operation - Setting set=1 after reset", test_num);

            reset = 1;
            set = 0;
            #10;

            reset = 0;
            set = 1;
            #10;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Logic (Set) - Verifying q stays 1 when both inputs go low", test_num);

            reset = 1;
            set = 0;
            #10;

            reset = 0;
            set = 1;
            #10;

            set = 0;
            #10;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Logic (Reset) - Verifying q stays 0 when both inputs go low", test_num);

            reset = 1;
            set = 0;
            #10;

            reset = 0;
            set = 0;
            #10;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Dominance - Checking behavior when both set and reset are high", test_num);

            reset = 1;
            set = 0;
            #10;

            reset = 1;
            set = 1;
            #10;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Toggle - Reset -> Set -> Reset", test_num);

            reset = 1;
            set = 0;
            #10;

            reset = 0;
            set = 1;
            #10;

            reset = 1;
            set = 0;
            #10;

            #1;


            check_outputs(0);
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
