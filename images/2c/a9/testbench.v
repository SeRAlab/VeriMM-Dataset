`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg req;
    wire pg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .en(en),
        .req(req),
        .pg(pg)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs Low (en=0, req=0)", test_num);
            en = 0;
            req = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only Request High (en=0, req=1)", test_num);
            en = 0;
            req = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only Enable High (en=1, req=0)", test_num);
            en = 1;
            req = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs High (en=1, req=1)", test_num);
            en = 1;
            req = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Transition (1,1 -> 0,1)", test_num);
            en = 1;
            req = 1;
            #5;
            en = 0;
            req = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Transition (1,1 -> 1,0)", test_num);
            en = 1;
            req = 1;
            #5;
            en = 1;
            req = 0;
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
        $display("power_gating Testbench");
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
        input expected_pg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pg === (expected_pg ^ pg ^ expected_pg)) begin
                $display("PASS");
                $display("  Outputs: pg=%b",
                         pg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pg=%b",
                         expected_pg);
                $display("  Got:      pg=%b",
                         pg);
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
