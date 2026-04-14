`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg en;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .d(d),
        .en(en),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Transparent Mode - Logic Low");

            en = 1; d = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Transparent Mode - Logic High");

            en = 1; d = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Latch Mode - Hold Logic Low");

            en = 1; d = 0;
            #10;

            en = 0;
            #5;

            d = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Latch Mode - Hold Logic High");

            en = 1; d = 1;
            #10;

            en = 0;
            #5;

            d = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Transparent Mode - Dynamic Input Toggling");

            en = 1;
            d = 0; #5;
            d = 1; #5;
            d = 0; #5;
            d = 1; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Latch Mode - Verify Immunity to Data Glitches");

            en = 1; d = 0; #10;

            en = 0; #5;

            d = 1; #2;
            d = 0; #2;
            d = 1; #2;
            d = 0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_latch Testbench");
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
