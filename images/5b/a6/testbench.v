`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg EN;
    reg [1:0] SEL;
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
        .EN(EN),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: EN=0 (Disabled), SEL=00, D0=1 - Y should be 0", test_num);
        EN = 0;
        SEL = 2'b00;
        D0 = 1; D1 = 0; D2 = 0; D3 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: EN=0 (Disabled), SEL=11, D3=1 - Y should be 0", test_num);
        EN = 0;
        SEL = 2'b11;
        D0 = 0; D1 = 0; D2 = 0; D3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: EN=1, SEL=00, D0=1 - Select D0 High", test_num);
        EN = 1;
        SEL = 2'b00;
        D0 = 1; D1 = 0; D2 = 0; D3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: EN=1, SEL=00, D0=0 - Select D0 Low", test_num);
        EN = 1;
        SEL = 2'b00;
        D0 = 0; D1 = 1; D2 = 1; D3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: EN=1, SEL=01, D1=1 - Select D1 High", test_num);
        EN = 1;
        SEL = 2'b01;
        D0 = 0; D1 = 1; D2 = 0; D3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: EN=1, SEL=01, D1=0 - Select D1 Low", test_num);
        EN = 1;
        SEL = 2'b01;
        D0 = 1; D1 = 0; D2 = 1; D3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: EN=1, SEL=10, D2=1 - Select D2 High", test_num);
        EN = 1;
        SEL = 2'b10;
        D0 = 0; D1 = 0; D2 = 1; D3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: EN=1, SEL=10, D2=0 - Select D2 Low", test_num);
        EN = 1;
        SEL = 2'b10;
        D0 = 1; D1 = 1; D2 = 0; D3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: EN=1, SEL=11, D3=1 - Select D3 High", test_num);
        EN = 1;
        SEL = 2'b11;
        D0 = 0; D1 = 0; D2 = 0; D3 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: EN=1, SEL=11, D3=0 - Select D3 Low", test_num);
        EN = 1;
        SEL = 2'b11;
        D0 = 1; D1 = 1; D2 = 1; D3 = 0;
        #1;

        check_outputs(1'b0);
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
