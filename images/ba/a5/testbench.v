`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg RST;
    wire [4:0] HOUR;
    wire [5:0] MIN;
    wire [5:0] SEC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .HOUR(HOUR),
        .MIN(MIN),
        .SEC(SEC)
    );
    task tick;

        input integer n;
        begin
            repeat(n) begin
                #5 CLK = 1;
                #5 CLK = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Increment 10 Seconds", test_num);
            reset_dut();
            tick(10);
            #1;

            check_outputs(0, 0, 10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Minute Roll-over (60s)", test_num);
            reset_dut();
            tick(60);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 59 Minutes and 59 Seconds", test_num);
            reset_dut();
            tick(3599);
            #1;

            check_outputs(0, 59, 59);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Hour Roll-over (1h)", test_num);
            reset_dut();
            tick(3600);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 23:59:59 check", test_num);
            reset_dut();
            tick(86399);
            #1;

            check_outputs(23, 59, 59);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 24-hour Wrap Around", test_num);
            reset_dut();
            tick(86400);
            #1;

            check_outputs(0, 0, 0);
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
        input [4:0] expected_HOUR;
        input [5:0] expected_MIN;
        input [5:0] expected_SEC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HOUR === (expected_HOUR ^ HOUR ^ expected_HOUR) &&
                expected_MIN === (expected_MIN ^ MIN ^ expected_MIN) &&
                expected_SEC === (expected_SEC ^ SEC ^ expected_SEC)) begin
                $display("PASS");
                $display("  Outputs: HOUR=%h, MIN=%h, SEC=%h",
                         HOUR, MIN, SEC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HOUR=%h, MIN=%h, SEC=%h",
                         expected_HOUR, expected_MIN, expected_SEC);
                $display("  Got:      HOUR=%h, MIN=%h, SEC=%h",
                         HOUR, MIN, SEC);
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
