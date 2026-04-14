`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg D4;
    reg D5;
    reg D6;
    reg D7;
    reg S0;
    reg S1;
    reg S2;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select D0, Input 0", test_num);
        {S2, S1, S0} = 3'b000;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11111110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select D0, Input 1", test_num);
        {S2, S1, S0} = 3'b000;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select D1, Input 0", test_num);
        {S2, S1, S0} = 3'b001;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11111101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select D1, Input 1", test_num);
        {S2, S1, S0} = 3'b001;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00000010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Select D2, Input 0", test_num);
        {S2, S1, S0} = 3'b010;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11111011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Select D2, Input 1", test_num);
        {S2, S1, S0} = 3'b010;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00000100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Select D3, Input 0", test_num);
        {S2, S1, S0} = 3'b011;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11110111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Select D3, Input 1", test_num);
        {S2, S1, S0} = 3'b011;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00001000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Select D4, Input 0", test_num);
        {S2, S1, S0} = 3'b100;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11101111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Select D4, Input 1", test_num);
        {S2, S1, S0} = 3'b100;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00010000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Select D5, Input 0", test_num);
        {S2, S1, S0} = 3'b101;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b11011111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Select D5, Input 1", test_num);
        {S2, S1, S0} = 3'b101;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b00100000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Select D6, Input 0", test_num);
        {S2, S1, S0} = 3'b110;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b10111111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test %0d: Select D6, Input 1", test_num);
        {S2, S1, S0} = 3'b110;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b01000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test %0d: Select D7, Input 0", test_num);
        {S2, S1, S0} = 3'b111;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b01111111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test %0d: Select D7, Input 1", test_num);
        {S2, S1, S0} = 3'b111;
        {D7, D6, D5, D4, D3, D2, D1, D0} = 8'b10000000;
        #1;

        check_outputs(1'b1);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
