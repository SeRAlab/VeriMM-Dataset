`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CS;
    reg DATA_IN;
    reg OE;
    reg STROBE;
    reg XTAL;
    wire [7:0] DATA_OUT;
    wire TP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CS(CS),
        .DATA_IN(DATA_IN),
        .OE(OE),
        .STROBE(STROBE),
        .XTAL(XTAL),
        .DATA_OUT(DATA_OUT),
        .TP(TP)
    );

    // Clock generation (10ns period)
    initial begin
        OE = 0;
        forever #5 OE = ~OE;
    end

        task reset_dut;

        begin
            CLK = 0;
            CS = 0;
            DATA_IN = 0;
            STROBE = 0;

            #20;
        end
        endtask
    task shift_in_data;

        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                DATA_IN = data[7-i];
                #10 CLK = 1;
                #10 CLK = 0;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Capture 0xA5...");
            reset_dut();
            CS = 1;
            shift_in_data(8'hA5);
            STROBE = 1;
            #20;
            #1;

            check_outputs(8'hA5, TP);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Capture 0x5A...");
            reset_dut();
            CS = 1;
            shift_in_data(8'h5A);
            STROBE = 1;
            #20;
            #1;

            check_outputs(8'h5A, TP);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Capture 0xFF...");
            reset_dut();
            CS = 1;
            shift_in_data(8'hFF);
            STROBE = 1;
            #20;
            #1;

            check_outputs(8'hFF, TP);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Capture 0x00...");
            reset_dut();
            CS = 1;
            shift_in_data(8'h00);
            STROBE = 1;
            #20;
            #1;

            check_outputs(8'h00, TP);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Pattern 0x3C...");
            reset_dut();
            CS = 1;
            shift_in_data(8'h3C);
            STROBE = 1;
            #20;

            #1;


            check_outputs(8'h3C, TP);
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
        input [7:0] expected_DATA_OUT;
        input expected_TP;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_TP === (expected_TP ^ TP ^ expected_TP)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, TP=%b",
                         DATA_OUT, TP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, TP=%b",
                         expected_DATA_OUT, expected_TP);
                $display("  Got:      DATA_OUT=%h, TP=%b",
                         DATA_OUT, TP);
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
        $dumpvars(0,CLK, CS, DATA_IN, OE, STROBE, XTAL, DATA_OUT, TP);
    end

endmodule
