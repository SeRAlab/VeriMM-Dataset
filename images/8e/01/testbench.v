`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] CHANNEL;
    reg CLK;
    reg REQUEST;
    reg SDI;
    wire BUSY;
    wire [11:0] CONV_RESULT;
    wire CS;
    wire SCLK;
    wire SDO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CHANNEL(CHANNEL),
        .CLK(CLK),
        .REQUEST(REQUEST),
        .SDI(SDI),
        .BUSY(BUSY),
        .CONV_RESULT(CONV_RESULT),
        .CS(CS),
        .SCLK(SCLK),
        .SDO(SDO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CHANNEL = 3'b000;
        REQUEST = 0;
        SDI = 0;

        repeat(5) @(posedge CLK);
    end
        endtask
    task simulate_spi_peripheral;

        input [15:0] data_to_send;
        integer i;
        begin

            wait(CS == 1'b0);


            for (i = 15; i >= 0; i = i - 1) begin
                @(negedge SCLK);
                SDI = data_to_send[i];
            end

            wait(BUSY == 1'b0);
            @(posedge CLK);
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 2, Data 0xA5C...", test_num);
        reset_dut();

        CHANNEL = 3'd2;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;


        simulate_spi_peripheral(16'hA5C0);


        #1;



        check_outputs(1'b0, 12'hA5C, 1'b1, 1'b0, SDO);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 5, Data 0x789...", test_num);
        reset_dut();

        CHANNEL = 3'd5;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;


        simulate_spi_peripheral(16'h789F);

        #1;


        check_outputs(1'b0, 12'h789, 1'b1, 1'b0, SDO);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros...", test_num);
        reset_dut();

        CHANNEL = 3'd0;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;

        simulate_spi_peripheral(16'h0000);

        #1;


        check_outputs(1'b0, 12'h000, 1'b1, 1'b0, SDO);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones...", test_num);
        reset_dut();

        CHANNEL = 3'd7;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;

        simulate_spi_peripheral(16'hFFFF);

        #1;


        check_outputs(1'b0, 12'hFFF, 1'b1, 1'b0, SDO);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Back-to-Back Conversion...", test_num);
        reset_dut();


        CHANNEL = 3'd1;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;
        simulate_spi_peripheral(16'h1230);


        CHANNEL = 3'd4;
        REQUEST = 1;
        @(posedge CLK);
        REQUEST = 0;
        simulate_spi_peripheral(16'h4560);

        #1;


        check_outputs(1'b0, 12'h456, 1'b1, 1'b0, SDO);
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
        input expected_BUSY;
        input [11:0] expected_CONV_RESULT;
        input expected_CS;
        input expected_SCLK;
        input expected_SDO;
        begin
            if (expected_BUSY === (expected_BUSY ^ BUSY ^ expected_BUSY) &&
                expected_CONV_RESULT === (expected_CONV_RESULT ^ CONV_RESULT ^ expected_CONV_RESULT) &&
                expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_SCLK === (expected_SCLK ^ SCLK ^ expected_SCLK) &&
                expected_SDO === (expected_SDO ^ SDO ^ expected_SDO)) begin
                $display("PASS");
                $display("  Outputs: BUSY=%b, CONV_RESULT=%h, CS=%b, SCLK=%b, SDO=%b",
                         BUSY, CONV_RESULT, CS, SCLK, SDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUSY=%b, CONV_RESULT=%h, CS=%b, SCLK=%b, SDO=%b",
                         expected_BUSY, expected_CONV_RESULT, expected_CS, expected_SCLK, expected_SDO);
                $display("  Got:      BUSY=%b, CONV_RESULT=%h, CS=%b, SCLK=%b, SDO=%b",
                         BUSY, CONV_RESULT, CS, SCLK, SDO);
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
        $dumpvars(0,CHANNEL, CLK, REQUEST, SDI, BUSY, CONV_RESULT, CS, SCLK, SDO);
    end

endmodule
