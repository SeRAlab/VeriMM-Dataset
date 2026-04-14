`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg En;
    wire Q;
    wire notQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .En(En),
        .Q(Q),
        .notQ(notQ)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Transparency Check (En=1, D=0)", test_num);

        En = 1; D = 1; #10;

        En = 1; D = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transparency Check (En=1, D=1)", test_num);

        En = 1; D = 0; #10;

        En = 1; D = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Hold Logic (Store 1, then change D)", test_num);

        En = 1; D = 1; #10;

        En = 0; #10;

        D = 0; #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Hold Logic (Store 0, then change D)", test_num);

        En = 1; D = 0; #10;

        En = 0; #10;

        D = 1; #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Continuous tracking when En=1", test_num);

        En = 1; D = 0; #10;

        D = 1; #10;
        D = 0; #10;
        D = 1; #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Re-enabling the latch", test_num);

        En = 1; D = 0; #10;
        En = 0; D = 1; #10;

        En = 1; #10;

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
        input expected_notQ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_notQ === (expected_notQ ^ notQ ^ expected_notQ)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, notQ=%b",
                         Q, notQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, notQ=%b",
                         expected_Q, expected_notQ);
                $display("  Got:      Q=%b, notQ=%b",
                         Q, notQ);
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
