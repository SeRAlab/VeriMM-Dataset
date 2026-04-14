`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg chip_select;
    reg clk;
    reg hold;
    reg [7:0] in_count_dato;
    reg [7:0] in_rtc_dato;
    reg reset;
    wire [7:0] out_dato_rtc;
    wire [7:0] out_dato_vga;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .chip_select(chip_select),
        .clk(clk),
        .hold(hold),
        .in_count_dato(in_count_dato),
        .in_rtc_dato(in_rtc_dato),
        .reset(reset),
        .out_dato_rtc(out_dato_rtc),
        .out_dato_vga(out_dato_vga)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            chip_select = 0;
            hold = 0;
            in_rtc_dato = 8'h00;
            in_count_dato = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            chip_select = 1;
            hold = 0;
            in_rtc_dato = 8'hAA;
            in_count_dato = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            chip_select = 1;
            hold = 0;
            in_rtc_dato = 8'h10;
            in_count_dato = 8'h20;
            @(posedge clk);
            #1;


            hold = 1;
            in_count_dato = 8'h30;
            in_rtc_dato = 8'h11;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11, 8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            chip_select = 0;
            hold = 0;
            in_rtc_dato = 8'hFF;
            in_count_dato = 8'hEE;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            chip_select = 1;
            hold = 1;
            in_count_dato = 8'h01;
            @(posedge clk);
            #1;


            in_count_dato = 8'h05;
            @(posedge clk);
            #1;


            hold = 0;
            in_count_dato = 8'h99;
            in_rtc_dato = 8'h88;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h88, 8'h99);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            chip_select = 1;
            hold = 0;
            in_rtc_dato = 8'h12;
            in_count_dato = 8'h34;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            chip_select = 1;
            hold = 0;
            in_count_dato = 8'hA1;
            @(posedge clk);
            #1;

            hold = 1;
            in_count_dato = 8'hB2;
            @(posedge clk);
            #1;
            in_count_dato = 8'hC3;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'hA1);
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
        input [7:0] expected_out_dato_rtc;
        input [7:0] expected_out_dato_vga;
        begin
            if (expected_out_dato_rtc === (expected_out_dato_rtc ^ out_dato_rtc ^ expected_out_dato_rtc) &&
                expected_out_dato_vga === (expected_out_dato_vga ^ out_dato_vga ^ expected_out_dato_vga)) begin
                $display("PASS");
                $display("  Outputs: out_dato_rtc=%h, out_dato_vga=%h",
                         out_dato_rtc, out_dato_vga);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_dato_rtc=%h, out_dato_vga=%h",
                         expected_out_dato_rtc, expected_out_dato_vga);
                $display("  Got:      out_dato_rtc=%h, out_dato_vga=%h",
                         out_dato_rtc, out_dato_vga);
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
        $dumpvars(0,chip_select, clk, hold, in_count_dato, in_rtc_dato, reset, out_dato_rtc, out_dato_vga);
    end

endmodule
