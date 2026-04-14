`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] index;
    reg [1:0] read_data_cycle;
    reg [7:0] read_data_register;
    reg write;
    reg [3:0] write_data;
    reg [1:0] write_data_cycle;
    reg [7:0] write_data_register;
    wire [3:0] blue;
    wire [3:0] green;
    wire [3:0] read_data;
    wire [3:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .index(index),
        .read_data_cycle(read_data_cycle),
        .read_data_register(read_data_register),
        .write(write),
        .write_data(write_data),
        .write_data_cycle(write_data_cycle),
        .write_data_register(write_data_register),
        .blue(blue),
        .green(green),
        .read_data(read_data),
        .red(red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            index = 0;
            read_data_cycle = 0;
            read_data_register = 0;
            write = 0;
            write_data = 0;
            write_data_cycle = 0;
            write_data_register = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Lookup Index 0x05", test_num);
            reset_dut();


            write = 1; write_data_register = 8'h05; write_data_cycle = 2'b00; write_data = 4'hA;
            @(posedge clk); #1;

            write = 1; write_data_register = 8'h05; write_data_cycle = 2'b01; write_data = 4'hB;
            @(posedge clk); #1;

            write = 1; write_data_register = 8'h05; write_data_cycle = 2'b10; write_data = 4'hC;
            @(posedge clk); #1;

            write = 0;
            index = 8'h05;
            @(posedge clk); #1;


            #1;



            check_outputs(4'hC, 4'hB, 0, 4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read Data Register Logic", test_num);
            reset_dut();


            write = 1; write_data_register = 8'hFF; write_data_cycle = 2'b00; write_data = 4'h7;
            @(posedge clk); #1;

            write = 0;
            read_data_register = 8'hFF;
            read_data_cycle = 2'b00;
            @(posedge clk); #1;


            #1;



            check_outputs(0, 0, 4'h7, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-index Independence", test_num);
            reset_dut();


            write = 1; write_data_register = 8'h10; write_data_cycle = 2'b00; write_data = 4'h1; @(posedge clk); #1;
            write = 1; write_data_register = 8'h10; write_data_cycle = 2'b01; write_data = 4'h2; @(posedge clk); #1;
            write = 1; write_data_register = 8'h10; write_data_cycle = 2'b10; write_data = 4'h3; @(posedge clk); #1;


            write = 1; write_data_register = 8'h20; write_data_cycle = 2'b00; write_data = 4'hF; @(posedge clk); #1;
            write = 1; write_data_register = 8'h20; write_data_cycle = 2'b01; write_data = 4'hE; @(posedge clk); #1;
            write = 1; write_data_register = 8'h20; write_data_cycle = 2'b10; write_data = 4'hD; @(posedge clk); #1;

            write = 0;
            index = 8'h10;
            @(posedge clk); #1;

            if (red == 4'h1 && green == 4'h2 && blue == 4'h3) begin
                 index = 8'h20;
                 @(posedge clk); #1;

                 #1;


                 check_outputs(4'hD, 4'hE, 0, 4'hF);
            end else begin
                 #1;

                 check_outputs(4'h3, 4'h2, 0, 4'h1);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Check", test_num);
            reset_dut();


            write = 1; write_data_register = 8'hAA; write_data_cycle = 2'b00; write_data = 4'h2;
            @(posedge clk); #1;


            write = 0; write_data_register = 8'hAA; write_data_cycle = 2'b00; write_data = 4'h9;
            @(posedge clk); #1;

            index = 8'hAA;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 0, 0, 4'h2);
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
        input [3:0] expected_blue;
        input [3:0] expected_green;
        input [3:0] expected_read_data;
        input [3:0] expected_red;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, read_data=%h, red=%h",
                         blue, green, read_data, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, read_data=%h, red=%h",
                         expected_blue, expected_green, expected_read_data, expected_red);
                $display("  Got:      blue=%h, green=%h, read_data=%h, red=%h",
                         blue, green, read_data, red);
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
        $dumpvars(0,clk, index, read_data_cycle, read_data_register, write, write_data, write_data_cycle, write_data_register, blue, green, read_data, red);
    end

endmodule
