`timescale 1ns/1ps

module fsm_next_state_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg [1:0] t;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_next_state dut (
        .b(b),
        .t(t),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State X (00), b=0 -> Next State Y (01), Q=0", test_num);
        t = 2'b00; b = 1'b0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State X (00), b=1 -> Next State Z (10), Q=1", test_num);
        t = 2'b00; b = 1'b1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State Y (01), b=0 -> Next State W (11), Q=1", test_num);
        t = 2'b01; b = 1'b0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State Y (01), b=1 -> Next State X (00), Q=0", test_num);
        t = 2'b01; b = 1'b1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State Z (10), b=0 -> Next State W (11), Q=1", test_num);
        t = 2'b10; b = 1'b0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State Z (10), b=1 -> Next State Y (01), Q=0", test_num);
        t = 2'b10; b = 1'b1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State W (11), b=0 -> Next State Z (10), Q=1", test_num);
        t = 2'b11; b = 1'b0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State W (11), b=1 -> Next State X (00), Q=0", test_num);
        t = 2'b11; b = 1'b1;
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
        $display("fsm_next_state Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
