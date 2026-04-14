`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENABLE_ERROR_DETECT;
    reg HARD_ERROR_RESET;
    reg RX_BUF_STATUS;
    reg RX_DISP_ERR;
    reg RX_NOT_IN_TABLE;
    reg RX_REALIGN;
    reg TX_BUF_ERR;
    reg TX_K_ERR;
    reg USER_CLK;
    wire HARD_ERROR;
    wire SOFT_ERROR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENABLE_ERROR_DETECT(ENABLE_ERROR_DETECT),
        .HARD_ERROR_RESET(HARD_ERROR_RESET),
        .RX_BUF_STATUS(RX_BUF_STATUS),
        .RX_DISP_ERR(RX_DISP_ERR),
        .RX_NOT_IN_TABLE(RX_NOT_IN_TABLE),
        .RX_REALIGN(RX_REALIGN),
        .TX_BUF_ERR(TX_BUF_ERR),
        .TX_K_ERR(TX_K_ERR),
        .USER_CLK(USER_CLK),
        .HARD_ERROR(HARD_ERROR),
        .SOFT_ERROR(SOFT_ERROR)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            ENABLE_ERROR_DETECT = 0;
            HARD_ERROR_RESET = 0;
            RX_BUF_STATUS = 0;
            RX_DISP_ERR = 0;
            RX_NOT_IN_TABLE = 0;
            RX_REALIGN = 0;
            TX_BUF_ERR = 0;
            TX_K_ERR = 0;
            @(posedge USER_CLK);
            HARD_ERROR_RESET = 1;
            @(posedge USER_CLK);
            HARD_ERROR_RESET = 0;
            @(posedge USER_CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Disabled Detection", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 0;
            RX_DISP_ERR = 1;
            RX_BUF_STATUS = 1;
            repeat(5) @(posedge USER_CLK);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Soft Error Detection (RX_REALIGN)", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 1;
            @(posedge USER_CLK);
            RX_REALIGN = 1;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Hard Error Counter (15 pulses)", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 1;
            @(posedge USER_CLK);
            for (i = 0; i < 15; i = i + 1) begin
                TX_K_ERR = 1;
                @(posedge USER_CLK);
                TX_K_ERR = 0;
                @(posedge USER_CLK);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Hard Error Reset", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 1;

            for (i = 0; i < 15; i = i + 1) begin
                RX_NOT_IN_TABLE = 1;
                @(posedge USER_CLK);
                RX_NOT_IN_TABLE = 0;
                @(posedge USER_CLK);
            end

            HARD_ERROR_RESET = 1;
            @(posedge USER_CLK);
            HARD_ERROR_RESET = 0;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Disable during Hard Error", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 1;

            for (i = 0; i < 15; i = i + 1) begin
                TX_BUF_ERR = 1;
                @(posedge USER_CLK);
                TX_BUF_ERR = 0;
                @(posedge USER_CLK);
            end

            ENABLE_ERROR_DETECT = 0;
            @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple Error Sources", test_num);
            reset_dut();
            ENABLE_ERROR_DETECT = 1;
            @(posedge USER_CLK);
            RX_BUF_STATUS = 1;
            TX_BUF_ERR = 1;
            RX_DISP_ERR = 1;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_HARD_ERROR;
        input expected_SOFT_ERROR;
        begin
            if (expected_HARD_ERROR === (expected_HARD_ERROR ^ HARD_ERROR ^ expected_HARD_ERROR) &&
                expected_SOFT_ERROR === (expected_SOFT_ERROR ^ SOFT_ERROR ^ expected_SOFT_ERROR)) begin
                $display("PASS");
                $display("  Outputs: HARD_ERROR=%b, SOFT_ERROR=%b",
                         HARD_ERROR, SOFT_ERROR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HARD_ERROR=%b, SOFT_ERROR=%b",
                         expected_HARD_ERROR, expected_SOFT_ERROR);
                $display("  Got:      HARD_ERROR=%b, SOFT_ERROR=%b",
                         HARD_ERROR, SOFT_ERROR);
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
        $dumpvars(0,ENABLE_ERROR_DETECT, HARD_ERROR_RESET, RX_BUF_STATUS, RX_DISP_ERR, RX_NOT_IN_TABLE, RX_REALIGN, TX_BUF_ERR, TX_K_ERR, USER_CLK, HARD_ERROR, SOFT_ERROR);
    end

endmodule
