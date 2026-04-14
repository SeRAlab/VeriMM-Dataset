`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg TXDLYBYPASS;
    reg TXOUTCLKPCS;
    reg TXOUTCLKPMA;
    reg [2:0] TXOUTCLKSEL;
    reg TXPLLREFCLK_DIV1;
    reg TXPLLREFCLK_DIV2;
    wire TXOUTCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TXDLYBYPASS(TXDLYBYPASS),
        .TXOUTCLKPCS(TXOUTCLKPCS),
        .TXOUTCLKPMA(TXOUTCLKPMA),
        .TXOUTCLKSEL(TXOUTCLKSEL),
        .TXPLLREFCLK_DIV1(TXPLLREFCLK_DIV1),
        .TXPLLREFCLK_DIV2(TXPLLREFCLK_DIV2),
        .TXOUTCLK(TXOUTCLK)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select TXOUTCLKPCS (Low)", test_num);
            TXOUTCLKSEL = 3'b001;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b1;
            TXPLLREFCLK_DIV1 = 1'b1;
            TXPLLREFCLK_DIV2 = 1'b1;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select TXOUTCLKPCS (High)", test_num);
            TXOUTCLKSEL = 3'b001;
            TXOUTCLKPCS = 1'b1;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select TXOUTCLKPMA (Low)", test_num);
            TXOUTCLKSEL = 3'b010;
            TXOUTCLKPCS = 1'b1;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b1;
            TXPLLREFCLK_DIV2 = 1'b1;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select TXOUTCLKPMA (High)", test_num);
            TXOUTCLKSEL = 3'b010;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b1;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select TXPLLREFCLK_DIV1 (Low)", test_num);
            TXOUTCLKSEL = 3'b011;
            TXOUTCLKPCS = 1'b1;
            TXOUTCLKPMA = 1'b1;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b1;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select TXPLLREFCLK_DIV1 (High)", test_num);
            TXOUTCLKSEL = 3'b011;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b1;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select TXPLLREFCLK_DIV2 (Low)", test_num);
            TXOUTCLKSEL = 3'b100;
            TXOUTCLKPCS = 1'b1;
            TXOUTCLKPMA = 1'b1;
            TXPLLREFCLK_DIV1 = 1'b1;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select TXPLLREFCLK_DIV2 (High)", test_num);
            TXOUTCLKSEL = 3'b100;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b1;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Invalid Selection 000 (Default High)", test_num);
            TXOUTCLKSEL = 3'b000;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Invalid Selection 111 (Default High)", test_num);
            TXOUTCLKSEL = 3'b111;
            TXOUTCLKPCS = 1'b0;
            TXOUTCLKPMA = 1'b0;
            TXPLLREFCLK_DIV1 = 1'b0;
            TXPLLREFCLK_DIV2 = 1'b0;
            TXDLYBYPASS = 1'b0;
            #10;
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
        input expected_TXOUTCLK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_TXOUTCLK === (expected_TXOUTCLK ^ TXOUTCLK ^ expected_TXOUTCLK)) begin
                $display("PASS");
                $display("  Outputs: TXOUTCLK=%b",
                         TXOUTCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TXOUTCLK=%b",
                         expected_TXOUTCLK);
                $display("  Got:      TXOUTCLK=%b",
                         TXOUTCLK);
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
