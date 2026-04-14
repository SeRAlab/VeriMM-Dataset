`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BAUD_CLK;
    reg RESET_N;
    reg [7:0] TX_BUFFER;
    reg TX_PARITY;
    reg TX_PAR_DIS;
    reg TX_START;
    reg TX_STOP;
    reg TX_WORD;
    wire TX_DATA;
    wire TX_DONE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BAUD_CLK(BAUD_CLK),
        .RESET_N(RESET_N),
        .TX_BUFFER(TX_BUFFER),
        .TX_PARITY(TX_PARITY),
        .TX_PAR_DIS(TX_PAR_DIS),
        .TX_START(TX_START),
        .TX_STOP(TX_STOP),
        .TX_WORD(TX_WORD),
        .TX_DATA(TX_DATA),
        .TX_DONE(TX_DONE)
    );

    // Clock generation (10ns period)
    initial begin
        BAUD_CLK = 0;
        forever #5 BAUD_CLK = ~BAUD_CLK;
    end

        task reset_dut;

    begin
        RESET_N = 0;
        TX_BUFFER = 8'h00;
        TX_PARITY = 0;
        TX_PAR_DIS = 1;
        TX_START = 0;
        TX_STOP = 1;
        TX_WORD = 1;
        repeat(2) @(posedge BAUD_CLK);
        RESET_N = 1;
        repeat(2) @(posedge BAUD_CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Transmitting 0x55, No Parity", test_num);
        reset_dut();

        TX_BUFFER = 8'h55;
        TX_PAR_DIS = 1;
        @(posedge BAUD_CLK);
        TX_START = 1;
        @(posedge BAUD_CLK);
        TX_START = 0;


        repeat(11) @(posedge BAUD_CLK);


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Transmitting 0xAA, No Parity", test_num);
        reset_dut();

        TX_BUFFER = 8'hAA;
        TX_PAR_DIS = 1;
        @(posedge BAUD_CLK);
        TX_START = 1;
        @(posedge BAUD_CLK);
        TX_START = 0;

        repeat(11) @(posedge BAUD_CLK);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Transmitting 0x00, Parity Enabled", test_num);
        reset_dut();

        TX_BUFFER = 8'h00;
        TX_PAR_DIS = 0;
        TX_PARITY = 0;
        @(posedge BAUD_CLK);
        TX_START = 1;
        @(posedge BAUD_CLK);
        TX_START = 0;


        repeat(12) @(posedge BAUD_CLK);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Transmitting 0xFF, Parity Enabled", test_num);
        reset_dut();

        TX_BUFFER = 8'hFF;
        TX_PAR_DIS = 0;
        TX_PARITY = 1;
        @(posedge BAUD_CLK);
        TX_START = 1;
        @(posedge BAUD_CLK);
        TX_START = 0;

        repeat(12) @(posedge BAUD_CLK);

        #1;


        check_outputs(1'b1, 1'b1);
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
        input expected_TX_DATA;
        input expected_TX_DONE;
        begin
            if (expected_TX_DATA === (expected_TX_DATA ^ TX_DATA ^ expected_TX_DATA) &&
                expected_TX_DONE === (expected_TX_DONE ^ TX_DONE ^ expected_TX_DONE)) begin
                $display("PASS");
                $display("  Outputs: TX_DATA=%b, TX_DONE=%b",
                         TX_DATA, TX_DONE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TX_DATA=%b, TX_DONE=%b",
                         expected_TX_DATA, expected_TX_DONE);
                $display("  Got:      TX_DATA=%b, TX_DONE=%b",
                         TX_DATA, TX_DONE);
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
        $dumpvars(0,BAUD_CLK, RESET_N, TX_BUFFER, TX_PARITY, TX_PAR_DIS, TX_START, TX_STOP, TX_WORD, TX_DATA, TX_DONE);
    end

endmodule
