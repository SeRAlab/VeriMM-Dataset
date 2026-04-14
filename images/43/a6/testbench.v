`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg i;
    wire A2;
    wire A3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .i(i),
        .A2(A2),
        .A3(A3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State P (a[1]=1), i=0 -> Expect A2=1 (Next State Q)", test_num);
        a = 4'b0010; i = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State P (a[1]=1), i=1 -> Expect A3=1 (Next State R)", test_num);
        a = 4'b0010; i = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State Q (a[2]=1), i=0 -> Expect A2=0, A3=0 (Next State S)", test_num);
        a = 4'b0100; i = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State Q (a[2]=1), i=1 -> Expect A2=0, A3=0 (Next State P)", test_num);
        a = 4'b0100; i = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State R (a[3]=1), i=0 -> Expect A2=0, A3=0 (Next State S)", test_num);
        a = 4'b1000; i = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State R (a[3]=1), i=1 -> Expect A2=1 (Next State Q)", test_num);
        a = 4'b1000; i = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S (a[0]=1), i=0 -> Expect A2=0, A3=0 (Next State P)", test_num);
        a = 4'b0001; i = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S (a[0]=1), i=1 -> Expect A3=1 (Next State R)", test_num);
        a = 4'b0001; i = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Invalid State (All Zeros) -> Expect A2=0, A3=0", test_num);
        a = 4'b0000; i = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Active States (P and R), i=1 -> Expect A2=1, A3=1", test_num);
        a = 4'b1010; i = 1;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_A2;
        input expected_A3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A2 === (expected_A2 ^ A2 ^ expected_A2) &&
                expected_A3 === (expected_A3 ^ A3 ^ expected_A3)) begin
                $display("PASS");
                $display("  Outputs: A2=%b, A3=%b",
                         A2, A3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A2=%b, A3=%b",
                         expected_A2, expected_A3);
                $display("  Got:      A2=%b, A3=%b",
                         A2, A3);
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
