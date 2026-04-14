`timescale 1ns/1ps

module DLatch_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg E;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DLatch dut (
        .D(D),
        .E(E),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Loading Logic High (Transparency)", test_num);

        E = 1; D = 0; #10;

        E = 1; D = 1; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Loading Logic Low (Transparency)", test_num);

        E = 1; D = 1; #10;

        E = 1; D = 0; #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Holding Logic High", test_num);

        E = 1; D = 1; #10;

        E = 0; #10;

        D = 0; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Holding Logic Low", test_num);

        E = 1; D = 0; #10;

        E = 0; #10;

        D = 1; #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rapid Data Changes when Enabled", test_num);

        E = 1; D = 0; #10;

        E = 1;
        D = 1; #5;
        D = 0; #5;
        D = 1; #5;
        D = 0; #5;
        D = 1; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Latched State Persistence", test_num);

        E = 1; D = 1; #10;

        E = 0; #5;

        D = 0; #2;
        D = 1; #2;
        D = 0; #2;
        D = 1; #10;
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
        $display("DLatch Testbench");
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
