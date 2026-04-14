`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg [3:0] d4;
    wire [3:0] digit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .d4(d4),
        .digit(digit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d1 (control=2'b00)", test_num);
            d1 = 4'hA; d2 = 4'h0; d3 = 4'h0; d4 = 4'h0;
            control = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d2 (control=2'b01)", test_num);
            d1 = 4'h0; d2 = 4'hB; d3 = 4'h0; d4 = 4'h0;
            control = 2'b01;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d3 (control=2'b10)", test_num);
            d1 = 4'h0; d2 = 4'h0; d3 = 4'hC; d4 = 4'h0;
            control = 2'b10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d4 (control=2'b11)", test_num);
            d1 = 4'h0; d2 = 4'h0; d3 = 4'h0; d4 = 4'hD;
            control = 2'b11;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify d1 select with diverse inputs", test_num);
            d1 = 4'h5; d2 = 4'hF; d3 = 4'hE; d4 = 4'h1;
            control = 2'b00;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify d2 select with diverse inputs", test_num);
            d1 = 4'h5; d2 = 4'hF; d3 = 4'hE; d4 = 4'h1;
            control = 2'b01;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify d3 select with diverse inputs", test_num);
            d1 = 4'h5; d2 = 4'hF; d3 = 4'hE; d4 = 4'h1;
            control = 2'b10;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify d4 select with diverse inputs", test_num);
            d1 = 4'h5; d2 = 4'hF; d3 = 4'hE; d4 = 4'h1;
            control = 2'b11;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            d1 = 4'h0; d2 = 4'h0; d3 = 4'h0; d4 = 4'h0;
            control = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs F", test_num);
            d1 = 4'hF; d2 = 4'hF; d3 = 4'hF; d4 = 4'hF;
            control = 2'b01;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_digit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digit === (expected_digit ^ digit ^ expected_digit)) begin
                $display("PASS");
                $display("  Outputs: digit=%h",
                         digit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%h",
                         expected_digit);
                $display("  Got:      digit=%h",
                         digit);
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
