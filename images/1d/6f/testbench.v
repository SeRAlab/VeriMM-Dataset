`timescale 1ns/1ps

module sr_latch_tb;

    // Testbench signals (combinational circuit)
    reg E;
    reg R;
    reg S;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sr_latch dut (
        .E(E),
        .R(R),
        .S(S),
        .Q(Q),
        .Qn(Qn)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Set Operation (E=1, S=1, R=0)", test_num);

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 1; R = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Reset Operation (E=1, S=0, R=1)", test_num);

            E = 1; S = 1; R = 0;
            #10;

            E = 1; S = 0; R = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Hold state with S=0, R=0 (E=1)", test_num);

            E = 1; S = 1; R = 0;
            #10;

            E = 1; S = 0; R = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Gating - No change when E=0 (Try Reset while Set)", test_num);

            E = 1; S = 1; R = 0;
            #10;

            E = 0; S = 0; R = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Gating - No change when E=0 (Try Set while Reset)", test_num);

            E = 1; S = 0; R = 1;
            #10;

            E = 0; S = 1; R = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Enable transition (Change S while E=0, then set E=1)", test_num);

            E = 1; S = 0; R = 1;
            #10;

            E = 0; S = 1; R = 0;
            #10;

            E = 1; S = 1; R = 0;
            #10;
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
        input expected_Q;
        input expected_Qn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
