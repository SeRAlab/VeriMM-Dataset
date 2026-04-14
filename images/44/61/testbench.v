`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    wire f0;
    wire f1;
    wire f2;
    wire f3;
    wire f4;
    wire f5;
    wire f6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .f0(f0),
        .f1(f1),
        .f2(f2),
        .f3(f3),
        .f4(f4),
        .f5(f5),
        .f6(f6)
    );
    task testcase001;

    begin
        {c3, c2, c1, c0} = 4'h0;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        {c3, c2, c1, c0} = 4'h1;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        {c3, c2, c1, c0} = 4'h2;
        #1;

        check_outputs(1, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        {c3, c2, c1, c0} = 4'h3;
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        {c3, c2, c1, c0} = 4'h4;
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        {c3, c2, c1, c0} = 4'h5;
        #1;

        check_outputs(1, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        {c3, c2, c1, c0} = 4'h6;
        #1;

        check_outputs(1, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        {c3, c2, c1, c0} = 4'h7;
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        {c3, c2, c1, c0} = 4'h8;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        {c3, c2, c1, c0} = 4'h9;
        #1;

        check_outputs(1, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase011;

    begin
        {c3, c2, c1, c0} = 4'hA;
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase012;

    begin
        {c3, c2, c1, c0} = 4'hB;
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase013;

    begin
        {c3, c2, c1, c0} = 4'hC;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase014;

    begin
        {c3, c2, c1, c0} = 4'hD;
        #1;

        check_outputs(0, 1, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase015;

    begin
        {c3, c2, c1, c0} = 4'hE;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase016;

    begin
        {c3, c2, c1, c0} = 4'hF;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_f0;
        input expected_f1;
        input expected_f2;
        input expected_f3;
        input expected_f4;
        input expected_f5;
        input expected_f6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f0 === (expected_f0 ^ f0 ^ expected_f0) &&
                expected_f1 === (expected_f1 ^ f1 ^ expected_f1) &&
                expected_f2 === (expected_f2 ^ f2 ^ expected_f2) &&
                expected_f3 === (expected_f3 ^ f3 ^ expected_f3) &&
                expected_f4 === (expected_f4 ^ f4 ^ expected_f4) &&
                expected_f5 === (expected_f5 ^ f5 ^ expected_f5) &&
                expected_f6 === (expected_f6 ^ f6 ^ expected_f6)) begin
                $display("PASS");
                $display("  Outputs: f0=%b, f1=%b, f2=%b, f3=%b, f4=%b, f5=%b, f6=%b",
                         f0, f1, f2, f3, f4, f5, f6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f0=%b, f1=%b, f2=%b, f3=%b, f4=%b, f5=%b, f6=%b",
                         expected_f0, expected_f1, expected_f2, expected_f3, expected_f4, expected_f5, expected_f6);
                $display("  Got:      f0=%b, f1=%b, f2=%b, f3=%b, f4=%b, f5=%b, f6=%b",
                         f0, f1, f2, f3, f4, f5, f6);
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
