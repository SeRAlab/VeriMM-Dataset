`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Clk;
    reg R;
    reg S;
    wire Qa;
    wire Qb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .R(R),
        .S(S),
        .Qa(Qa),
        .Qb(Qb)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Set while Clk is High", test_num);
            Clk = 1; R = 0; S = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Hold while Clk is High", test_num);
            Clk = 1; R = 0; S = 1;
            #10;
            S = 0; R = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reset while Clk is High", test_num);
            Clk = 1; S = 0; R = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold while Clk is High after Reset", test_num);
            Clk = 1; S = 0; R = 1;
            #10;
            S = 0; R = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Set is blocked when Clk is Low", test_num);

            Clk = 1; S = 0; R = 1;
            #10;

            Clk = 0; S = 1; R = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify Reset is blocked when Clk is Low", test_num);

            Clk = 1; S = 1; R = 0;
            #10;

            Clk = 0; S = 0; R = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Hold state through Clk falling edge", test_num);
            Clk = 1; S = 1; R = 0;
            #10;
            Clk = 0;
            #10;
            S = 0; R = 0;
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_Qa;
        input expected_Qb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Qa === (expected_Qa ^ Qa ^ expected_Qa) &&
                expected_Qb === (expected_Qb ^ Qb ^ expected_Qb)) begin
                $display("PASS");
                $display("  Outputs: Qa=%b, Qb=%b",
                         Qa, Qb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Qa=%b, Qb=%b",
                         expected_Qa, expected_Qb);
                $display("  Got:      Qa=%b, Qb=%b",
                         Qa, Qb);
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
