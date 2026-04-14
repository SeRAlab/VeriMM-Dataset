`timescale 1ns/1ps

module mux_4_to_1_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg S0;
    reg S1;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4_to_1 dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .S0(S0),
        .S1(S1),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select D0 (S0=0, S1=0) with D0=1");
            D0 = 1; D1 = 0; D2 = 0; D3 = 0;
            S0 = 0; S1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select D0 (S0=0, S1=0) with D0=0, other inputs high");
            D0 = 0; D1 = 1; D2 = 1; D3 = 1;
            S0 = 0; S1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select D1 (S0=0, S1=1) with D1=1");
            D0 = 0; D1 = 1; D2 = 0; D3 = 0;
            S0 = 0; S1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select D1 (S0=0, S1=1) with D1=0, other inputs high");
            D0 = 1; D1 = 0; D2 = 1; D3 = 1;
            S0 = 0; S1 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select D2 (S0=1, S1=0) with D2=1");
            D0 = 0; D1 = 0; D2 = 1; D3 = 0;
            S0 = 1; S1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select D2 (S0=1, S1=0) with D2=0, other inputs high");
            D0 = 1; D1 = 1; D2 = 0; D3 = 1;
            S0 = 1; S1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select D3 (S0=1, S1=1) with D3=1");
            D0 = 0; D1 = 0; D2 = 0; D3 = 1;
            S0 = 1; S1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select D3 (S0=1, S1=1) with D3=0, other inputs high");
            D0 = 1; D1 = 1; D2 = 1; D3 = 0;
            S0 = 1; S1 = 1;
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
        $display("mux_4_to_1 Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
