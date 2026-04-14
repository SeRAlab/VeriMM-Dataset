`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg E;
    reg G;
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .E(E),
        .G(G),
        .R(R),
        .S(S),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;

        R = 0; S = 1; D = 0; E = 0; G = 0;
        #10;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        R = 0; S = 1; E = 0; G = 0; #5;

        R = 1; S = 0;
        #10;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        R = 0; S = 1; #5;

        R = 1; S = 1; E = 1; G = 0; D = 1;
        #10;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        R = 0; S = 1; #5;


        R = 1; S = 0; #5;
        R = 1; S = 1; E = 1; G = 0; D = 0;
        #10;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        R = 0; S = 1; #5;

        R = 1; S = 1; E = 1; G = 0; D = 1; #5;
        G = 1;
        D = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        R = 0; S = 1; #5;

        R = 1; S = 1; E = 1; G = 0; D = 0; #5;
        E = 0;
        D = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        R = 0; S = 1; #5;

        R = 0; S = 0;
        #10;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        R = 0; S = 1; #5;

        R = 1; S = 1; E = 1; G = 1; D = 1;
        #10;

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
        $display("top_module Testbench");
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
