`timescale 1ns/1ps

module state_fsm_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [3:0] w;
    wire W2;
    wire W3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_fsm dut (
        .r(r),
        .w(w),
        .W2(W2),
        .W3(W3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: From State R (0001), r=0 -> Expect Next State S (W2=1, W3=0)", test_num);
            w = 4'b0001; r = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: From State R (0001), r=1 -> Expect Next State T (W2=0, W3=1)", test_num);
            w = 4'b0001; r = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: From State S (0010), r=0 -> Expect Next State R (W2=0, W3=0)", test_num);
            w = 4'b0010; r = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: From State S (0010), r=1 -> Expect Next State U (W2=0, W3=0)", test_num);
            w = 4'b0010; r = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: From State T (0100), r=0 -> Expect Next State U (W2=0, W3=0)", test_num);
            w = 4'b0100; r = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: From State T (0100), r=1 -> Expect Next State R (W2=0, W3=0)", test_num);
            w = 4'b0100; r = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: From State U (1000), r=0 -> Expect Next State S (W2=1, W3=0)", test_num);
            w = 4'b1000; r = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: From State U (1000), r=1 -> Expect Next State T (W2=0, W3=1)", test_num);
            w = 4'b1000; r = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Invalid State (0000), r=0 -> Expect No Transitions (W2=0, W3=0)", test_num);
            w = 4'b0000; r = 0;
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
        $display("state_fsm Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_W2;
        input expected_W3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W2 === (expected_W2 ^ W2 ^ expected_W2) &&
                expected_W3 === (expected_W3 ^ W3 ^ expected_W3)) begin
                $display("PASS");
                $display("  Outputs: W2=%b, W3=%b",
                         W2, W3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W2=%b, W3=%b",
                         expected_W2, expected_W3);
                $display("  Got:      W2=%b, W3=%b",
                         W2, W3);
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
