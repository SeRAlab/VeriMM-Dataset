`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] CPLLREFCLKSEL;
    reg GTGREFCLK;
    reg GTNORTHREFCLK0;
    reg GTNORTHREFCLK1;
    reg GTREFCLK0;
    reg GTREFCLK1;
    reg GTSOUTHREFCLK0;
    reg GTSOUTHREFCLK1;
    wire CPLL_MUX_CLK_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CPLLREFCLKSEL(CPLLREFCLKSEL),
        .GTGREFCLK(GTGREFCLK),
        .GTNORTHREFCLK0(GTNORTHREFCLK0),
        .GTNORTHREFCLK1(GTNORTHREFCLK1),
        .GTREFCLK0(GTREFCLK0),
        .GTREFCLK1(GTREFCLK1),
        .GTSOUTHREFCLK0(GTSOUTHREFCLK0),
        .GTSOUTHREFCLK1(GTSOUTHREFCLK1),
        .CPLL_MUX_CLK_OUT(CPLL_MUX_CLK_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Selecting GTREFCLK0, value 1", test_num);
            CPLLREFCLKSEL = 3'b001;
            GTREFCLK0 = 1'b1;
            GTREFCLK1 = 1'b0; GTNORTHREFCLK0 = 1'b0; GTNORTHREFCLK1 = 1'b0;
            GTSOUTHREFCLK0 = 1'b0; GTSOUTHREFCLK1 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Selecting GTREFCLK0, value 0", test_num);
            CPLLREFCLKSEL = 3'b001;
            GTREFCLK0 = 1'b0;
            GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1; GTNORTHREFCLK1 = 1'b1;
            GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Selecting GTREFCLK1, value 1", test_num);
            CPLLREFCLKSEL = 3'b010;
            GTREFCLK1 = 1'b1;
            GTREFCLK0 = 1'b0; GTNORTHREFCLK0 = 1'b0; GTNORTHREFCLK1 = 1'b0;
            GTSOUTHREFCLK0 = 1'b0; GTSOUTHREFCLK1 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Selecting GTREFCLK1, value 0", test_num);
            CPLLREFCLKSEL = 3'b010;
            GTREFCLK1 = 1'b0;
            GTREFCLK0 = 1'b1; GTNORTHREFCLK0 = 1'b1; GTNORTHREFCLK1 = 1'b1;
            GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Selecting GTNORTHREFCLK0, value 1", test_num);
            CPLLREFCLKSEL = 3'b011;
            GTNORTHREFCLK0 = 1'b1;
            GTREFCLK0 = 1'b0; GTREFCLK1 = 1'b0; GTNORTHREFCLK1 = 1'b0;
            GTSOUTHREFCLK0 = 1'b0; GTSOUTHREFCLK1 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Selecting GTNORTHREFCLK0, value 0", test_num);
            CPLLREFCLKSEL = 3'b011;
            GTNORTHREFCLK0 = 1'b0;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK1 = 1'b1;
            GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Selecting GTNORTHREFCLK1, value 1", test_num);
            CPLLREFCLKSEL = 3'b100;
            GTNORTHREFCLK1 = 1'b1;
            GTREFCLK0 = 1'b0; GTREFCLK1 = 1'b0; GTNORTHREFCLK0 = 1'b0;
            GTSOUTHREFCLK0 = 1'b0; GTSOUTHREFCLK1 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Selecting GTNORTHREFCLK1, value 0", test_num);
            CPLLREFCLKSEL = 3'b100;
            GTNORTHREFCLK1 = 1'b0;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1;
            GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Selecting GTSOUTHREFCLK0, value 1", test_num);
            CPLLREFCLKSEL = 3'b101;
            GTSOUTHREFCLK0 = 1'b1;
            GTREFCLK0 = 1'b0; GTREFCLK1 = 1'b0; GTNORTHREFCLK0 = 1'b0;
            GTNORTHREFCLK1 = 1'b0; GTSOUTHREFCLK1 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Selecting GTSOUTHREFCLK0, value 0", test_num);
            CPLLREFCLKSEL = 3'b101;
            GTSOUTHREFCLK0 = 1'b0;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1;
            GTNORTHREFCLK1 = 1'b1; GTSOUTHREFCLK1 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %03d: Selecting GTSOUTHREFCLK1, value 1", test_num);
            CPLLREFCLKSEL = 3'b110;
            GTSOUTHREFCLK1 = 1'b1;
            GTREFCLK0 = 1'b0; GTREFCLK1 = 1'b0; GTNORTHREFCLK0 = 1'b0;
            GTNORTHREFCLK1 = 1'b0; GTSOUTHREFCLK0 = 1'b0; GTGREFCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %03d: Selecting GTSOUTHREFCLK1, value 0", test_num);
            CPLLREFCLKSEL = 3'b110;
            GTSOUTHREFCLK1 = 1'b0;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1;
            GTNORTHREFCLK1 = 1'b1; GTSOUTHREFCLK0 = 1'b1; GTGREFCLK = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %03d: Selecting GTGREFCLK, value 1", test_num);
            CPLLREFCLKSEL = 3'b111;
            GTGREFCLK = 1'b1;
            GTREFCLK0 = 1'b0; GTREFCLK1 = 1'b0; GTNORTHREFCLK0 = 1'b0;
            GTNORTHREFCLK1 = 1'b0; GTSOUTHREFCLK0 = 1'b0; GTSOUTHREFCLK1 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Testcase %03d: Selecting GTGREFCLK, value 0", test_num);
            CPLLREFCLKSEL = 3'b111;
            GTGREFCLK = 1'b0;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1;
            GTNORTHREFCLK1 = 1'b1; GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Testcase %03d: Selecting Default (000), expect 0", test_num);
            CPLLREFCLKSEL = 3'b000;
            GTREFCLK0 = 1'b1; GTREFCLK1 = 1'b1; GTNORTHREFCLK0 = 1'b1;
            GTNORTHREFCLK1 = 1'b1; GTSOUTHREFCLK0 = 1'b1; GTSOUTHREFCLK1 = 1'b1;
            GTGREFCLK = 1'b1;
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_CPLL_MUX_CLK_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CPLL_MUX_CLK_OUT === (expected_CPLL_MUX_CLK_OUT ^ CPLL_MUX_CLK_OUT ^ expected_CPLL_MUX_CLK_OUT)) begin
                $display("PASS");
                $display("  Outputs: CPLL_MUX_CLK_OUT=%b",
                         CPLL_MUX_CLK_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CPLL_MUX_CLK_OUT=%b",
                         expected_CPLL_MUX_CLK_OUT);
                $display("  Got:      CPLL_MUX_CLK_OUT=%b",
                         CPLL_MUX_CLK_OUT);
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
