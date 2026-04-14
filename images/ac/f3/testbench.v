`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IN0;
    reg IN1;
    reg IN2;
    reg IN3;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        {IN3, IN2, IN1, IN0} = 4'd0;
        #1;

        check_outputs(EXPECTED_INIT[0]);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {IN3, IN2, IN1, IN0} = 4'd1;
        #1;

        check_outputs(EXPECTED_INIT[1]);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {IN3, IN2, IN1, IN0} = 4'd2;
        #1;

        check_outputs(EXPECTED_INIT[2]);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {IN3, IN2, IN1, IN0} = 4'd3;
        #1;

        check_outputs(EXPECTED_INIT[3]);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {IN3, IN2, IN1, IN0} = 4'd4;
        #1;

        check_outputs(EXPECTED_INIT[4]);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {IN3, IN2, IN1, IN0} = 4'd5;
        #1;

        check_outputs(EXPECTED_INIT[5]);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {IN3, IN2, IN1, IN0} = 4'd6;
        #1;

        check_outputs(EXPECTED_INIT[6]);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {IN3, IN2, IN1, IN0} = 4'd7;
        #1;

        check_outputs(EXPECTED_INIT[7]);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {IN3, IN2, IN1, IN0} = 4'd8;
        #1;

        check_outputs(EXPECTED_INIT[8]);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {IN3, IN2, IN1, IN0} = 4'd9;
        #1;

        check_outputs(EXPECTED_INIT[9]);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        {IN3, IN2, IN1, IN0} = 4'd10;
        #1;

        check_outputs(EXPECTED_INIT[10]);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        {IN3, IN2, IN1, IN0} = 4'd11;
        #1;

        check_outputs(EXPECTED_INIT[11]);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        {IN3, IN2, IN1, IN0} = 4'd12;
        #1;

        check_outputs(EXPECTED_INIT[12]);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        {IN3, IN2, IN1, IN0} = 4'd13;
        #1;

        check_outputs(EXPECTED_INIT[13]);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        {IN3, IN2, IN1, IN0} = 4'd14;
        #1;

        check_outputs(EXPECTED_INIT[14]);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        {IN3, IN2, IN1, IN0} = 4'd15;
        #1;

        check_outputs(EXPECTED_INIT[15]);
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
        input expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
