`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EN_in;
    reg RST;
    reg SW1;
    wire Green1;
    wire Green2;
    wire Red1;
    wire Red2;
    wire Yellow1;
    wire Yellow2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN_in(EN_in),
        .RST(RST),
        .SW1(SW1),
        .Green1(Green1),
        .Green2(Green2),
        .Red1(Red1),
        .Red2(Red2),
        .Yellow1(Yellow1),
        .Yellow2(Yellow2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset Priority (RST=0, SW1=1, EN=00)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 0; SW1 = 1; EN_in = 2'b00;
        #10;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verify Switch Safety (RST=1, SW1=0, EN=10)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 1; SW1 = 0; EN_in = 2'b10;
        #10;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Normal Operation EN=00 (Lane 1 Green, Lane 2 Red)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 1; SW1 = 1; EN_in = 2'b00;
        #10;

        #1;


        check_outputs(1, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Normal Operation EN=01 (Lane 1 Yellow, Lane 2 Red)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 1; SW1 = 1; EN_in = 2'b01;
        #10;

        #1;


        check_outputs(0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Normal Operation EN=10 (Lane 1 Red, Lane 2 Green)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 1; SW1 = 1; EN_in = 2'b10;
        #10;

        #1;


        check_outputs(0, 1, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Normal Operation EN=11 (Lane 1 Red, Lane 2 Yellow)", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 1; SW1 = 1; EN_in = 2'b11;
        #10;

        #1;


        check_outputs(0, 0, 1, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verify Reset/Switch Combo Disable", test_num);

        RST = 0; SW1 = 0; EN_in = 2'b00;
        #10;

        RST = 0; SW1 = 0; EN_in = 2'b11;
        #10;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
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
        input expected_Green1;
        input expected_Green2;
        input expected_Red1;
        input expected_Red2;
        input expected_Yellow1;
        input expected_Yellow2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Green1 === (expected_Green1 ^ Green1 ^ expected_Green1) &&
                expected_Green2 === (expected_Green2 ^ Green2 ^ expected_Green2) &&
                expected_Red1 === (expected_Red1 ^ Red1 ^ expected_Red1) &&
                expected_Red2 === (expected_Red2 ^ Red2 ^ expected_Red2) &&
                expected_Yellow1 === (expected_Yellow1 ^ Yellow1 ^ expected_Yellow1) &&
                expected_Yellow2 === (expected_Yellow2 ^ Yellow2 ^ expected_Yellow2)) begin
                $display("PASS");
                $display("  Outputs: Green1=%b, Green2=%b, Red1=%b, Red2=%b, Yellow1=%b, Yellow2=%b",
                         Green1, Green2, Red1, Red2, Yellow1, Yellow2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Green1=%b, Green2=%b, Red1=%b, Red2=%b, Yellow1=%b, Yellow2=%b",
                         expected_Green1, expected_Green2, expected_Red1, expected_Red2, expected_Yellow1, expected_Yellow2);
                $display("  Got:      Green1=%b, Green2=%b, Red1=%b, Red2=%b, Yellow1=%b, Yellow2=%b",
                         Green1, Green2, Red1, Red2, Yellow1, Yellow2);
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
