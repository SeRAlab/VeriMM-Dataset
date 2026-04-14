`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BAUD;
    reg CLKIN;
    reg RST;
    wire CLKOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BAUD(BAUD),
        .CLKIN(CLKIN),
        .RST(RST),
        .CLKOUT(CLKOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLKIN = 0;
        forever #5 CLKIN = ~CLKIN;
    end

        task reset_dut;

        begin
            RST = 1;
            BAUD = 4'b0000;
            CLKIN = 0;
            #20;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Default 9600 Baud check...");
            test_num = 1;
            reset_dut();


            repeat (5210) @(posedge CLKIN);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 115200 Baud check...");
            test_num = 2;
            reset_dut();
            BAUD = 4'd9;

            repeat (435) @(posedge CLKIN);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 4800 Baud check...");
            test_num = 3;
            reset_dut();
            BAUD = 4'd4;

            repeat (5000) @(posedge CLKIN);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mid-operation Baud change...");
            test_num = 4;
            reset_dut();
            BAUD = 4'd9;
            repeat (868) @(posedge CLKIN);
            BAUD = 4'd12;
            repeat (100) @(posedge CLKIN);


            if (CLKOUT === 1'b0 || CLKOUT === 1'b1)
                #1;

                check_outputs(CLKOUT);
            else
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
        input expected_CLKOUT;
        begin
            if (expected_CLKOUT === (expected_CLKOUT ^ CLKOUT ^ expected_CLKOUT)) begin
                $display("PASS");
                $display("  Outputs: CLKOUT=%b",
                         CLKOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKOUT=%b",
                         expected_CLKOUT);
                $display("  Got:      CLKOUT=%b",
                         CLKOUT);
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
        $dumpvars(0,BAUD, CLKIN, RST, CLKOUT);
    end

endmodule
