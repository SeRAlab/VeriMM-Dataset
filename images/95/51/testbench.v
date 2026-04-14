`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg [15:0] PeriodH_i;
    reg [15:0] PeriodL_i;
    reg Reset_n_i;
    wire LED_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .PeriodH_i(PeriodH_i),
        .PeriodL_i(PeriodL_i),
        .Reset_n_i(Reset_n_i),
        .LED_o(LED_o)
    );

    // Clock generation (10ns period)
    initial begin
        Clk_i = 0;
        forever #5 Clk_i = ~Clk_i;
    end

        task reset_dut;

        begin
            Reset_n_i = 0;
            PeriodH_i = 0;
            PeriodL_i = 0;
            repeat(2) @(posedge Clk_i);
            #1;
            Reset_n_i = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify LED ON during High phase", test_num);
            reset_dut();
            PeriodH_i = 16'd10;
            PeriodL_i = 16'd10;

            repeat(5) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify LED OFF during Low phase", test_num);
            reset_dut();
            PeriodH_i = 16'd5;
            PeriodL_i = 16'd10;

            repeat(10) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify cyclical transition back to ON", test_num);
            reset_dut();
            PeriodH_i = 16'd4;
            PeriodL_i = 16'd4;

            repeat(10) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asymmetric periods (Long High, Short Low)", test_num);
            reset_dut();
            PeriodH_i = 16'd20;
            PeriodL_i = 16'd2;

            repeat(18) @(posedge Clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asymmetric periods (Short High, Long Low)", test_num);
            reset_dut();
            PeriodH_i = 16'd2;
            PeriodL_i = 16'd20;

            repeat(7) @(posedge Clk_i);
            #1;
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
        input expected_LED_o;
        begin
            if (expected_LED_o === (expected_LED_o ^ LED_o ^ expected_LED_o)) begin
                $display("PASS");
                $display("  Outputs: LED_o=%b",
                         LED_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_o=%b",
                         expected_LED_o);
                $display("  Got:      LED_o=%b",
                         LED_o);
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
        $dumpvars(0,Clk_i, PeriodH_i, PeriodL_i, Reset_n_i, LED_o);
    end

endmodule
