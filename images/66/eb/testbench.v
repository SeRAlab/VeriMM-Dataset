`timescale 1ns/1ps

module fsm_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [3:0] t;
    wire T2;
    wire T3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm dut (
        .r(r),
        .t(t),
        .T2(T2),
        .T3(T3)
    );
    task testcase001;

        begin
            $display("Testcase 001: State W (t=0001), r=0 -> Expected T2=1, T3=0");
            r = 1'b0;
            t = 4'b0001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State W (t=0001), r=1 -> Expected T2=0, T3=1");
            r = 1'b1;
            t = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: State X (t=0010), r=0 -> Expected T2=0, T3=0");
            r = 1'b0;
            t = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State X (t=0010), r=1 -> Expected T2=0, T3=0");
            r = 1'b1;
            t = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State Y (t=0100), r=0 -> Expected T2=0, T3=0");
            r = 1'b0;
            t = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State Y (t=0100), r=1 -> Expected T2=0, T3=0");
            r = 1'b1;
            t = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: State Z (t=1000), r=0 -> Expected T2=1, T3=0");
            r = 1'b0;
            t = 4'b1000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: State Z (t=1000), r=1 -> Expected T2=0, T3=1");
            r = 1'b1;
            t = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm Testbench");
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
        input expected_T2;
        input expected_T3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T2 === (expected_T2 ^ T2 ^ expected_T2) &&
                expected_T3 === (expected_T3 ^ T3 ^ expected_T3)) begin
                $display("PASS");
                $display("  Outputs: T2=%b, T3=%b",
                         T2, T3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T2=%b, T3=%b",
                         expected_T2, expected_T3);
                $display("  Got:      T2=%b, T3=%b",
                         T2, T3);
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
