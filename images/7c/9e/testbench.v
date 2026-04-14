`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ein;
    reg [3:0] I;
    wire Eout;
    wire GS;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ein(Ein),
        .I(I),
        .Eout(Eout),
        .GS(GS),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled - Ein=0, I=4'b1111", test_num);
            Ein = 0;
            I = 4'b1111;
            #1;

            check_outputs(1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enabled, No Input - Ein=1, I=4'b0000", test_num);
            Ein = 1;
            I = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Bit 0 - Ein=1, I=4'b0001", test_num);
            Ein = 1;
            I = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Bit 1 - Ein=1, I=4'b0010", test_num);
            Ein = 1;
            I = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Bit 2 - Ein=1, I=4'b0100", test_num);
            Ein = 1;
            I = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b1, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Bit 3 - Ein=1, I=4'b1000", test_num);
            Ein = 1;
            I = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b1, 2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (Bit 3 over Bit 0) - Ein=1, I=4'b1001", test_num);
            Ein = 1;
            I = 4'b1001;
            #1;

            check_outputs(1'b0, 1'b1, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (Bit 2 over Bits 1,0) - Ein=1, I=4'b0111", test_num);
            Ein = 1;
            I = 4'b0111;
            #1;

            check_outputs(1'b0, 1'b1, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (Bit 1 over Bit 0) - Ein=1, I=4'b0011", test_num);
            Ein = 1;
            I = 4'b0011;
            #1;

            check_outputs(1'b0, 1'b1, 2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Bits High - Ein=1, I=4'b1111", test_num);
            Ein = 1;
            I = 4'b1111;
            #1;

            check_outputs(1'b0, 1'b1, 2'b11);
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
        input expected_Eout;
        input expected_GS;
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Eout === (expected_Eout ^ Eout ^ expected_Eout) &&
                expected_GS === (expected_GS ^ GS ^ expected_GS) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Eout=%b, GS=%b, Y=%h",
                         Eout, GS, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Eout=%b, GS=%b, Y=%h",
                         expected_Eout, expected_GS, expected_Y);
                $display("  Got:      Eout=%b, GS=%b, Y=%h",
                         Eout, GS, Y);
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
