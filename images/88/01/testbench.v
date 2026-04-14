`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] DCR_ABus;
    reg [31:0] DCR_DBusIn;
    reg DCR_Read;
    reg DCR_Write;
    reg clk;
    reg rst;
    wire DCR_Ack;
    wire [31:0] DCR_DBusOut;
    wire [10:0] tft_base_addr;
    wire tft_dps_reg;
    wire tft_on_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DCR_ABus(DCR_ABus),
        .DCR_DBusIn(DCR_DBusIn),
        .DCR_Read(DCR_Read),
        .DCR_Write(DCR_Write),
        .clk(clk),
        .rst(rst),
        .DCR_Ack(DCR_Ack),
        .DCR_DBusOut(DCR_DBusOut),
        .tft_base_addr(tft_base_addr),
        .tft_dps_reg(tft_dps_reg),
        .tft_on_reg(tft_on_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            DCR_ABus = 0;
            DCR_DBusIn = 0;
            DCR_Read = 0;
            DCR_Write = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset state verification");
            reset_dut();

            #1;


            check_outputs(0, 32'h0, 11'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Write to tft_base_addr");
            reset_dut();

            @(posedge clk);
            DCR_ABus = 10'h000;
            DCR_DBusIn = 32'h0000_04D2;
            DCR_Write = 1;

            @(posedge clk);
            #1;


            @(posedge clk);
            DCR_Write = 0;
            DCR_ABus = 0;
            DCR_DBusIn = 0;


            #1;



            check_outputs(0, 32'h0, 11'h4D2, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Write to Control Register (On/DPS bits)");
            reset_dut();

            @(posedge clk);
            DCR_ABus = 10'h001;
            DCR_DBusIn = 32'h0000_0003;
            DCR_Write = 1;

            @(posedge clk);
            @(posedge clk);
            DCR_Write = 0;


            #1;



            check_outputs(0, 32'h0, 11'h0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Read back from Address 0");
            reset_dut();


            @(posedge clk);
            DCR_ABus = 10'h000;
            DCR_DBusIn = 32'h0000_05AA;
            DCR_Write = 1;
            @(posedge clk);
            DCR_Write = 0;


            @(posedge clk);
            DCR_ABus = 10'h000;
            DCR_Read = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(DCR_Ack, 32'h0000_05AA, 11'h5AA, 0, 0);

            @(posedge clk);
            DCR_Read = 0;
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Read back from Address 1");
            reset_dut();


            @(posedge clk);
            DCR_ABus = 10'h001;
            DCR_DBusIn = 32'h0000_0001;
            DCR_Write = 1;
            @(posedge clk);
            DCR_Write = 0;


            @(posedge clk);
            DCR_ABus = 10'h001;
            DCR_Read = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(DCR_Ack, 32'h0000_0001, 11'h0, 0, 1);

            @(posedge clk);
            DCR_Read = 0;
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Write to invalid address");
            reset_dut();

            @(posedge clk);
            DCR_ABus = 10'h3FF;
            DCR_DBusIn = 32'hFFFF_FFFF;
            DCR_Write = 1;

            @(posedge clk);
            DCR_Write = 0;


            #1;



            check_outputs(0, 32'h0, 11'h0, 0, 0);
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
        input expected_DCR_Ack;
        input [31:0] expected_DCR_DBusOut;
        input [10:0] expected_tft_base_addr;
        input expected_tft_dps_reg;
        input expected_tft_on_reg;
        begin
            if (expected_DCR_Ack === (expected_DCR_Ack ^ DCR_Ack ^ expected_DCR_Ack) &&
                expected_DCR_DBusOut === (expected_DCR_DBusOut ^ DCR_DBusOut ^ expected_DCR_DBusOut) &&
                expected_tft_base_addr === (expected_tft_base_addr ^ tft_base_addr ^ expected_tft_base_addr) &&
                expected_tft_dps_reg === (expected_tft_dps_reg ^ tft_dps_reg ^ expected_tft_dps_reg) &&
                expected_tft_on_reg === (expected_tft_on_reg ^ tft_on_reg ^ expected_tft_on_reg)) begin
                $display("PASS");
                $display("  Outputs: DCR_Ack=%b, DCR_DBusOut=%h, tft_base_addr=%h, tft_dps_reg=%b, tft_on_reg=%b",
                         DCR_Ack, DCR_DBusOut, tft_base_addr, tft_dps_reg, tft_on_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DCR_Ack=%b, DCR_DBusOut=%h, tft_base_addr=%h, tft_dps_reg=%b, tft_on_reg=%b",
                         expected_DCR_Ack, expected_DCR_DBusOut, expected_tft_base_addr, expected_tft_dps_reg, expected_tft_on_reg);
                $display("  Got:      DCR_Ack=%b, DCR_DBusOut=%h, tft_base_addr=%h, tft_dps_reg=%b, tft_on_reg=%b",
                         DCR_Ack, DCR_DBusOut, tft_base_addr, tft_dps_reg, tft_on_reg);
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
        $dumpvars(0,DCR_ABus, DCR_DBusIn, DCR_Read, DCR_Write, clk, rst, DCR_Ack, DCR_DBusOut, tft_base_addr, tft_dps_reg, tft_on_reg);
    end

endmodule
