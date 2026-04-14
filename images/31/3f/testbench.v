`timescale 1ns/1ps

module D_latch_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg en;
    wire q;
    wire q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    D_latch dut (
        .d(d),
        .en(en),
        .q(q),
        .q_n(q_n)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Transparent mode - Driving logic high");

        en = 1; d = 0; #10;

        en = 1; d = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Transparent mode - Driving logic low");

        en = 1; d = 1; #10;

        en = 1; d = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Hold mode - Maintaining logic high");

        en = 1; d = 1; #10;

        en = 0; #10;

        d = 0;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Hold mode - Maintaining logic low");

        en = 1; d = 0; #10;

        en = 0; #10;

        d = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Re-enabling transparency from hold");

        en = 1; d = 0; #10;
        en = 0; d = 1; #10;

        en = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Multiple data transitions while enabled");

        en = 1; d = 0; #10;

        d = 1; #10;
        d = 0; #10;
        d = 1; #10;

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
        $display("D_latch Testbench");
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
        input expected_q_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_n === (expected_q_n ^ q_n ^ expected_q_n)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_n=%b",
                         q, q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_n=%b",
                         expected_q, expected_q_n);
                $display("  Got:      q=%b, q_n=%b",
                         q, q_n);
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
