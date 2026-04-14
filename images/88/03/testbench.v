`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENA_COMMA_ALIGN;
    reg RX_REC_CLK;
    wire ENA_CALIGN_REC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENA_COMMA_ALIGN(ENA_COMMA_ALIGN),
        .RX_REC_CLK(RX_REC_CLK),
        .ENA_CALIGN_REC(ENA_CALIGN_REC)
    );

    // Clock generation (10ns period)
    initial begin
        RX_REC_CLK = 0;
        forever #5 RX_REC_CLK = ~RX_REC_CLK;
    end

        task reset_dut;

        begin
            ENA_COMMA_ALIGN = 0;
            repeat(4) @(posedge RX_REC_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagation of logic 1", test_num);
            reset_dut();

            @(negedge RX_REC_CLK);
            ENA_COMMA_ALIGN = 1;


            repeat(2) @(posedge RX_REC_CLK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant logic 0", test_num);
            reset_dut();

            @(negedge RX_REC_CLK);
            ENA_COMMA_ALIGN = 0;

            repeat(2) @(posedge RX_REC_CLK);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained logic 1", test_num);
            reset_dut();

            @(negedge RX_REC_CLK);
            ENA_COMMA_ALIGN = 1;

            repeat(5) @(posedge RX_REC_CLK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High to Low transition latency", test_num);
            reset_dut();


            @(negedge RX_REC_CLK);
            ENA_COMMA_ALIGN = 1;
            repeat(2) @(posedge RX_REC_CLK);


            @(negedge RX_REC_CLK);
            ENA_COMMA_ALIGN = 0;


            repeat(2) @(posedge RX_REC_CLK);
            #2;

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
        input expected_ENA_CALIGN_REC;
        begin
            if (expected_ENA_CALIGN_REC === (expected_ENA_CALIGN_REC ^ ENA_CALIGN_REC ^ expected_ENA_CALIGN_REC)) begin
                $display("PASS");
                $display("  Outputs: ENA_CALIGN_REC=%b",
                         ENA_CALIGN_REC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENA_CALIGN_REC=%b",
                         expected_ENA_CALIGN_REC);
                $display("  Got:      ENA_CALIGN_REC=%b",
                         ENA_CALIGN_REC);
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
        $dumpvars(0,ENA_COMMA_ALIGN, RX_REC_CLK, ENA_CALIGN_REC);
    end

endmodule
