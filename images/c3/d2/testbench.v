`timescale 1ns/1ps

module sky130_fd_sc_ms__dlrtp_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg GATE;
    reg RESET_B;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_ms__dlrtp dut (
        .D(D),
        .GATE(GATE),
        .RESET_B(RESET_B),
        .Q(Q)
    );
    task testcase001;

    begin
        $display("Test 001: Reset functionality - Force Q low when RESET_B is high");
        RESET_B = 1;
        D = 1;
        GATE = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test 002: Transparent mode - Q follows D=1 when GATE=1, RESET_B=0");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test 003: Transparent mode - Q follows D=0 when GATE=1, RESET_B=0");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test 004: Latch mode - Hold logic 1 when GATE drops low");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 1;
        #5;
        GATE = 0;
        #2;
        D = 0;
        #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test 005: Latch mode - Hold logic 0 when GATE drops low");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 0;
        #5;
        GATE = 0;
        #2;
        D = 1;
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test 006: Reset priority - RESET_B overrides GATE and D");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 1;
        #5;

        RESET_B = 1;
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Test 007: Multiple data transitions in transparent mode");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1;
        D = 0; #5;
        D = 1; #5;
        D = 0; #5;
        D = 1; #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Test 008: Latch hold through input noise");
        RESET_B = 1; #5;
        RESET_B = 0;
        GATE = 1; D = 1; #5;
        GATE = 0; #5;

        D = 0; #2;
        D = 1; #2;
        D = 0; #5;
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
        $display("sky130_fd_sc_ms__dlrtp Testbench");
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
