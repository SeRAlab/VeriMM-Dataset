`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg clk_IBUF_BUFG;
    wire FSM_selector_C;
    wire [1:0] FSM_sequential_state_reg_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .FSM_selector_C(FSM_selector_C),
        .FSM_sequential_state_reg_reg(FSM_sequential_state_reg_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk_IBUF_BUFG = 0;
        forever #5 clk_IBUF_BUFG = ~clk_IBUF_BUFG;
    end

        task reset_dut;

        begin
            AR = 0;

            force FSM_selector_C = 1'b1;
            @(posedge clk_IBUF_BUFG);
            #1;
            release FSM_selector_C;

        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Increment 00 -> 01");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG);
            #1;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Increment 00 -> 10");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reach state 11 (Selector High)");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Auto-reset from 11 to 00");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Hold state when AR=0");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG); #1;
            AR = 0;
            @(posedge clk_IBUF_BUFG); #1;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Reset priority over AR=0 at state 11");
            reset_dut();
            AR = 1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            @(posedge clk_IBUF_BUFG); #1;
            AR = 0;
            @(posedge clk_IBUF_BUFG); #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Verify multiple wraparounds");
            reset_dut();
            AR = 1;

            repeat(6) @(posedge clk_IBUF_BUFG);
            #1;
            #1;

            check_outputs(1'b0, 2'b10);
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
        input expected_FSM_selector_C;
        input [1:0] expected_FSM_sequential_state_reg_reg;
        begin
            if (expected_FSM_selector_C === (expected_FSM_selector_C ^ FSM_selector_C ^ expected_FSM_selector_C) &&
                expected_FSM_sequential_state_reg_reg === (expected_FSM_sequential_state_reg_reg ^ FSM_sequential_state_reg_reg ^ expected_FSM_sequential_state_reg_reg)) begin
                $display("PASS");
                $display("  Outputs: FSM_selector_C=%b, FSM_sequential_state_reg_reg=%h",
                         FSM_selector_C, FSM_sequential_state_reg_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FSM_selector_C=%b, FSM_sequential_state_reg_reg=%h",
                         expected_FSM_selector_C, expected_FSM_sequential_state_reg_reg);
                $display("  Got:      FSM_selector_C=%b, FSM_sequential_state_reg_reg=%h",
                         FSM_selector_C, FSM_sequential_state_reg_reg);
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
        $dumpvars(0,AR, clk_IBUF_BUFG, FSM_selector_C, FSM_sequential_state_reg_reg);
    end

endmodule
