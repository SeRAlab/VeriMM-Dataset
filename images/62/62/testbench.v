`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg reset;
    wire [3:0] counter;
    wire [6:0] seven_seg;
    wire [7:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .counter(counter),
        .seven_seg(seven_seg),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, get_seg_hex(0), 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single cycle, data[7]=1");
            test_num = 2;
            reset_dut();
            data = 8'h80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, get_seg_hex(2), 8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 3 cycles with alternating data bits (1, 0, 1)");
            test_num = 3;
            reset_dut();


            data = 8'h80; @(posedge clk); #1;

            data = 8'h00; @(posedge clk); #1;

            data = 8'h80; @(posedge clk); #1;


            #1;



            check_outputs(4'h3, get_seg_hex(8), 8'h05);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: 5 cycles, data[7]=0");
            test_num = 4;
            reset_dut();
            data = 8'h00;
            for(i=0; i<5; i=i+1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'h5, get_seg_hex(5), 8'h00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: 8 cycles, data[7]=1 (SR full)");
            test_num = 5;
            reset_dut();
            data = 8'h80;
            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
            end
            #1;



            #1;




            check_outputs(4'h8, get_seg_hex(15), 8'hFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: 16 cycles to check counter wrap-around");
            test_num = 6;
            reset_dut();
            data = 8'h00;
            for(i=0; i<16; i=i+1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'h0, get_seg_hex(0), 8'h00);
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
        input [3:0] expected_counter;
        input [6:0] expected_seven_seg;
        input [7:0] expected_shift_reg;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg) &&
                expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, seven_seg=%h, shift_reg=%h",
                         counter, seven_seg, shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, seven_seg=%h, shift_reg=%h",
                         expected_counter, expected_seven_seg, expected_shift_reg);
                $display("  Got:      counter=%h, seven_seg=%h, shift_reg=%h",
                         counter, seven_seg, shift_reg);
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
        $dumpvars(0,clk, data, reset, counter, seven_seg, shift_reg);
    end

endmodule
