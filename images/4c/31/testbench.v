`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BTN;
    reg [7:0] SW;
    reg [31:0] adr_i;
    reg clk;
    reg counter0_out;
    reg counter1_out;
    reg counter2_out;
    reg [31:0] counter_out;
    reg [31:0] dat_i;
    reg [7:0] led_out;
    reg rst;
    reg stb_i;
    reg we_i;
    wire GPIOfffffe00_we;
    wire GPIOffffff00_we;
    wire [31:0] Peripheral_in;
    wire ack_o;
    wire counter_we;
    wire [31:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTN(BTN),
        .SW(SW),
        .adr_i(adr_i),
        .clk(clk),
        .counter0_out(counter0_out),
        .counter1_out(counter1_out),
        .counter2_out(counter2_out),
        .counter_out(counter_out),
        .dat_i(dat_i),
        .led_out(led_out),
        .rst(rst),
        .stb_i(stb_i),
        .we_i(we_i),
        .GPIOfffffe00_we(GPIOfffffe00_we),
        .GPIOffffff00_we(GPIOffffff00_we),
        .Peripheral_in(Peripheral_in),
        .ack_o(ack_o),
        .counter_we(counter_we),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            BTN = 4'hA;
            SW = 8'hF0;
            adr_i = 32'h0;
            dat_i = 32'h0;
            stb_i = 0;
            we_i = 0;
            counter_out = 32'h12345678;
            counter0_out = 0;
            counter1_out = 0;
            counter2_out = 0;
            led_out = 8'h00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest %0d: Write to GPIO FFFFFF00", test_num);
            adr_i = 32'hffffff00;
            dat_i = 32'hA5A5A5A5;
            we_i = 1;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 32'hA5A5A5A5, 1'b1, 1'b0, 32'h000000F0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest %0d: Write to GPIO FFFFFE00", test_num);
            adr_i = 32'hfffffe00;
            dat_i = 32'h55AA55AA;
            we_i = 1;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 32'h55AA55AA, 1'b1, 1'b0, 32'h0000000A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest %0d: Write to Counter FFFFFF10", test_num);
            adr_i = 32'hffffff10;
            dat_i = 32'hFFFFFFFF;
            we_i = 1;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'hFFFFFFFF, 1'b1, 1'b1, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest %0d: Read from FFFFFF00 (SW)", test_num);
            adr_i = 32'hffffff00;
            we_i = 0;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b1, 1'b0, 32'h000000F0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest %0d: Read from FFFFFE00 (BTN)", test_num);
            adr_i = 32'hfffffe00;
            we_i = 0;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b1, 1'b0, 32'h0000000A);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTest %0d: Read from FFFFFF10 (Counter)", test_num);
            adr_i = 32'hffffff10;
            we_i = 0;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b1, 1'b0, 32'h12345678);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTest %0d: Bus Idle (Strobe=0)", test_num);
            adr_i = 32'hffffff00;
            we_i = 1;
            stb_i = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("\nTest %0d: Unmapped Address Read", test_num);
            adr_i = 32'h00000000;
            we_i = 0;
            stb_i = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b1, 1'b0, 32'h0);
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
        input expected_GPIOfffffe00_we;
        input expected_GPIOffffff00_we;
        input [31:0] expected_Peripheral_in;
        input expected_ack_o;
        input expected_counter_we;
        input [31:0] expected_dat_o;
        begin
            if (expected_GPIOfffffe00_we === (expected_GPIOfffffe00_we ^ GPIOfffffe00_we ^ expected_GPIOfffffe00_we) &&
                expected_GPIOffffff00_we === (expected_GPIOffffff00_we ^ GPIOffffff00_we ^ expected_GPIOffffff00_we) &&
                expected_Peripheral_in === (expected_Peripheral_in ^ Peripheral_in ^ expected_Peripheral_in) &&
                expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_counter_we === (expected_counter_we ^ counter_we ^ expected_counter_we) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: GPIOfffffe00_we=%b, GPIOffffff00_we=%b, Peripheral_in=%h, ack_o=%b, counter_we=%b, dat_o=%h",
                         GPIOfffffe00_we, GPIOffffff00_we, Peripheral_in, ack_o, counter_we, dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIOfffffe00_we=%b, GPIOffffff00_we=%b, Peripheral_in=%h, ack_o=%b, counter_we=%b, dat_o=%h",
                         expected_GPIOfffffe00_we, expected_GPIOffffff00_we, expected_Peripheral_in, expected_ack_o, expected_counter_we, expected_dat_o);
                $display("  Got:      GPIOfffffe00_we=%b, GPIOffffff00_we=%b, Peripheral_in=%h, ack_o=%b, counter_we=%b, dat_o=%h",
                         GPIOfffffe00_we, GPIOffffff00_we, Peripheral_in, ack_o, counter_we, dat_o);
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
        $dumpvars(0,BTN, SW, adr_i, clk, counter0_out, counter1_out, counter2_out, counter_out, dat_i, led_out, rst, stb_i, we_i, GPIOfffffe00_we, GPIOffffff00_we, Peripheral_in, ack_o, counter_we, dat_o);
    end

endmodule
