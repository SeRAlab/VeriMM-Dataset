`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] A;
    reg [17:0] B;
    wire [35:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero multiplication (0 * 0)", test_num);
        A = 18'sd0;
        B = 18'sd0;
        #10;
        #1;

        check_outputs(36'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive identity (123 * 1)", test_num);
        A = 18'sd123;
        B = 18'sd1;
        #10;
        #1;

        check_outputs(36'sd123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive * Negative (10 * -5)", test_num);
        A = 18'sd10;
        B = -18'sd5;
        #10;
        #1;

        check_outputs(-36'sd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative * Negative (-1 * -1)", test_num);
        A = -18'sd1;
        B = -18'sd1;
        #10;
        #1;

        check_outputs(36'sd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max positive squared", test_num);
        A = 18'h1FFFF;
        B = 18'h1FFFF;
        #10;

        #1;


        check_outputs(36'h003FFFE0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max negative squared", test_num);
        A = 18'h20000;
        B = 18'h20000;
        #10;

        #1;


        check_outputs(36'h00400000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max negative * Max positive", test_num);
        A = 18'h20000;
        B = 18'h1FFFF;
        #10;

        #1;


        check_outputs(36'hFC00020000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative identity (500 * -1)", test_num);
        A = 18'sd500;
        B = -18'sd1;
        #10;
        #1;

        check_outputs(-36'sd500);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed values (1000 * -5)", test_num);
        A = 18'sd1000;
        B = -18'sd5;
        #10;
        #1;

        check_outputs(-36'sd5000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero by negative (0 * -12345)", test_num);
        A = 18'sd0;
        B = -18'sd12345;
        #10;
        #1;

        check_outputs(36'sd0);
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
        testcase009();
        testcase010();
        
        
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
        input [35:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
