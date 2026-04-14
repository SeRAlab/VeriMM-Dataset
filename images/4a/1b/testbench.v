`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DELAY_EN;
    reg [11:0] DELAY_MS;
    reg RST;
    wire DELAY_FIN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DELAY_EN(DELAY_EN),
        .DELAY_MS(DELAY_MS),
        .RST(RST),
        .DELAY_FIN(DELAY_FIN)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            DELAY_EN = 0;
            DELAY_MS = 0;
            @(posedge CLK);
            #2 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic 1ms Delay", test_num);
            reset_dut();
            DELAY_MS = 12'd1;
            DELAY_EN = 1;


            #1000050;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset during Hold", test_num);
            reset_dut();
            DELAY_MS = 12'd5;
            DELAY_EN = 1;


            #500000;
            RST = 1;
            #100;
            RST = 0;


            #5000000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Disable EN prematurely", test_num);
            reset_dut();
            DELAY_MS = 12'd2;
            DELAY_EN = 1;

            #1000000;
            DELAY_EN = 0;
            #1100000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: FIN clearing after EN=0", test_num);
            reset_dut();
            DELAY_MS = 12'd1;
            DELAY_EN = 1;

            #1000050;
            if (DELAY_FIN === 1'b1) begin
                DELAY_EN = 0;
                @(posedge CLK);
                #2;
                #1;

                check_outputs(1'b0);
            end else begin
                $display("FAIL: Delay did not finish as expected for clearing test");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 3ms Delay", test_num);
            reset_dut();
            DELAY_MS = 12'd3;
            DELAY_EN = 1;

            #3000050;

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
        input expected_DELAY_FIN;
        begin
            if (expected_DELAY_FIN === (expected_DELAY_FIN ^ DELAY_FIN ^ expected_DELAY_FIN)) begin
                $display("PASS");
                $display("  Outputs: DELAY_FIN=%b",
                         DELAY_FIN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DELAY_FIN=%b",
                         expected_DELAY_FIN);
                $display("  Got:      DELAY_FIN=%b",
                         DELAY_FIN);
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
        $dumpvars(0,CLK, DELAY_EN, DELAY_MS, RST, DELAY_FIN);
    end

endmodule
