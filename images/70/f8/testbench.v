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
            #20;
            RST = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Delay (Short)", test_num);
            reset_dut();

            DELAY_MS = 12'd5;
            DELAY_EN = 1;



            for(i = 0; i < 1000; i = i + 1) begin
                @(posedge CLK);
                if (DELAY_FIN) break;
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during timing", test_num);
            reset_dut();

            DELAY_MS = 12'd50;
            DELAY_EN = 1;


            repeat(10) @(posedge CLK);


            RST = 1;
            repeat(5) @(posedge CLK);
            RST = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable EN during timing", test_num);
            reset_dut();

            DELAY_MS = 12'd20;
            DELAY_EN = 1;


            repeat(10) @(posedge CLK);


            DELAY_EN = 0;


            repeat(30) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Delay Value", test_num);
            reset_dut();

            DELAY_MS = 12'd0;
            DELAY_EN = 1;


            repeat(5) @(posedge CLK);

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
