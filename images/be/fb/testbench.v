`timescale 1ns/1ps

module sr_latch_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire q;
    wire q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sr_latch dut (
        .r(r),
        .s(s),
        .q(q),
        .q_bar(q_bar)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State (S=0, R=1)", test_num);

        s = 0; r = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Set State (S=1, R=0)", test_num);

        s = 0; r = 1; #10;

        s = 1; r = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold State after Set (S=0, R=0)", test_num);

        s = 0; r = 1; #10;

        s = 1; r = 0; #10;

        s = 0; r = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold State after Reset (S=0, R=0)", test_num);

        s = 0; r = 1; #10;

        s = 0; r = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition from Set to Reset", test_num);

        s = 0; r = 1; #10;

        s = 1; r = 0; #10;

        s = 0; r = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Forbidden State (S=1, R=1)", test_num);

        s = 0; r = 1; #10;

        s = 1; r = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sr_latch Testbench");
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
        input expected_q_bar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_bar=%b",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_bar=%b",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%b, q_bar=%b",
                         q, q_bar);
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
