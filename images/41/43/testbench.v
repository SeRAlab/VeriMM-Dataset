`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg VPWR;
    wire W;
    wire X;
    wire Y;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .VPWR(VPWR),
        .W(W),
        .X(X),
        .Y(Y),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=0, A2=0, B1=0, VPWR=0", test_num);
        A1 = 0; A2 = 0; B1 = 0; VPWR = 0;

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=0, A2=1, B1=0, VPWR=1", test_num);
        A1 = 0; A2 = 1; B1 = 0; VPWR = 1;

        #1;


        check_outputs(0, 0, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=1, A2=0, B1=1, VPWR=0", test_num);
        A1 = 1; A2 = 0; B1 = 1; VPWR = 0;

        #1;


        check_outputs(0, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=1, A2=1, B1=1, VPWR=1", test_num);
        A1 = 1; A2 = 1; B1 = 1; VPWR = 1;

        #1;


        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=0, A2=0, B1=1, VPWR=1", test_num);
        A1 = 0; A2 = 0; B1 = 1; VPWR = 1;

        #1;


        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=1, A2=1, B1=0, VPWR=0", test_num);
        A1 = 1; A2 = 1; B1 = 0; VPWR = 0;

        #1;


        check_outputs(0, 1, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A1=0, A2=1, B1=1, VPWR=1", test_num);
        A1 = 0; A2 = 1; B1 = 1; VPWR = 1;

        #1;


        check_outputs(1, 0, 1, 1);
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
        input expected_W;
        input expected_X;
        input expected_Y;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W === (expected_W ^ W ^ expected_W) &&
                expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: W=%b, X=%b, Y=%b, Z=%b",
                         W, X, Y, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W=%b, X=%b, Y=%b, Z=%b",
                         expected_W, expected_X, expected_Y, expected_Z);
                $display("  Got:      W=%b, X=%b, Y=%b, Z=%b",
                         W, X, Y, Z);
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
