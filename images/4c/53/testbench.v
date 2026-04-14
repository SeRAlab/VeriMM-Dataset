`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENABLE_ERR_DETECT;
    reg ILLEGAL_BTF;
    reg RXDATAVALID_IN;
    reg RX_BUF_ERR;
    reg RX_HEADER_0;
    reg RX_HEADER_1;
    reg RX_HEADER_ERR;
    reg TX_BUF_ERR;
    reg USER_CLK;
    wire HARD_ERR;
    wire HARD_ERR_RESET;
    wire SOFT_ERR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENABLE_ERR_DETECT(ENABLE_ERR_DETECT),
        .ILLEGAL_BTF(ILLEGAL_BTF),
        .RXDATAVALID_IN(RXDATAVALID_IN),
        .RX_BUF_ERR(RX_BUF_ERR),
        .RX_HEADER_0(RX_HEADER_0),
        .RX_HEADER_1(RX_HEADER_1),
        .RX_HEADER_ERR(RX_HEADER_ERR),
        .TX_BUF_ERR(TX_BUF_ERR),
        .USER_CLK(USER_CLK),
        .HARD_ERR(HARD_ERR),
        .HARD_ERR_RESET(HARD_ERR_RESET),
        .SOFT_ERR(SOFT_ERR)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            ENABLE_ERR_DETECT = 0;
            ILLEGAL_BTF = 0;
            RXDATAVALID_IN = 0;
            RX_BUF_ERR = 0;
            RX_HEADER_0 = 0;
            RX_HEADER_1 = 1;
            RX_HEADER_ERR = 0;
            TX_BUF_ERR = 0;
            @(posedge USER_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ENABLE_ERR_DETECT = 0;
            RX_BUF_ERR = 1;
            RX_HEADER_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ENABLE_ERR_DETECT = 1;
            RX_BUF_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ENABLE_ERR_DETECT = 1;
            TX_BUF_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ENABLE_ERR_DETECT = 1;
            RXDATAVALID_IN = 1;
            RX_HEADER_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ENABLE_ERR_DETECT = 1;
            RXDATAVALID_IN = 1;
            RX_HEADER_0 = 0;
            RX_HEADER_1 = 0;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            ENABLE_ERR_DETECT = 1;
            RXDATAVALID_IN = 1;
            RX_HEADER_0 = 1;
            RX_HEADER_1 = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            ENABLE_ERR_DETECT = 1;
            RXDATAVALID_IN = 1;
            ILLEGAL_BTF = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            ENABLE_ERR_DETECT = 1;
            RXDATAVALID_IN = 0;
            RX_HEADER_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            ENABLE_ERR_DETECT = 1;
            RX_BUF_ERR = 1;
            RXDATAVALID_IN = 1;
            RX_HEADER_ERR = 1;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_HARD_ERR;
        input expected_HARD_ERR_RESET;
        input expected_SOFT_ERR;
        begin
            if (expected_HARD_ERR === (expected_HARD_ERR ^ HARD_ERR ^ expected_HARD_ERR) &&
                expected_HARD_ERR_RESET === (expected_HARD_ERR_RESET ^ HARD_ERR_RESET ^ expected_HARD_ERR_RESET) &&
                expected_SOFT_ERR === (expected_SOFT_ERR ^ SOFT_ERR ^ expected_SOFT_ERR)) begin
                $display("PASS");
                $display("  Outputs: HARD_ERR=%b, HARD_ERR_RESET=%b, SOFT_ERR=%b",
                         HARD_ERR, HARD_ERR_RESET, SOFT_ERR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HARD_ERR=%b, HARD_ERR_RESET=%b, SOFT_ERR=%b",
                         expected_HARD_ERR, expected_HARD_ERR_RESET, expected_SOFT_ERR);
                $display("  Got:      HARD_ERR=%b, HARD_ERR_RESET=%b, SOFT_ERR=%b",
                         HARD_ERR, HARD_ERR_RESET, SOFT_ERR);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ENABLE_ERR_DETECT, ILLEGAL_BTF, RXDATAVALID_IN, RX_BUF_ERR, RX_HEADER_0, RX_HEADER_1, RX_HEADER_ERR, TX_BUF_ERR, USER_CLK, HARD_ERR, HARD_ERR_RESET, SOFT_ERR);
    end

endmodule
