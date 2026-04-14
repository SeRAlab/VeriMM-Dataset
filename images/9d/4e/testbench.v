`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg [7:0] read_addr;
    reg read_en;
    reg reset;
    reg [1:0] shift_direction;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .read_addr(read_addr),
        .read_en(read_en),
        .reset(reset),
        .shift_direction(shift_direction),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            load = 0;
            read_addr = 0;
            read_en = 0;
            shift_direction = 0;
            write_addr = 0;
            write_data = 0;
            write_en = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RAM Write/Read and SR Load", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 8'h05; write_data = 4'hA;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            load = 1; data_in = 8'hF0;
            @(posedge clk);
            load = 0;


            @(posedge clk);
            read_en = 1; read_addr = 8'h05;


            @(posedge clk);
            #2 #1;
 check_outputs(8'hF0 ^ 8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Operation", test_num);
            reset_dut();


            @(posedge clk);
            load = 1; data_in = 8'h55;
            @(posedge clk);
            load = 0;


            @(posedge clk);
            shift_direction = 2'b01;
            @(posedge clk);
            @(posedge clk);
            shift_direction = 2'b00;


            @(posedge clk);
            read_en = 1; read_addr = 8'hAA;

            @(posedge clk);
            #2 #1;
 check_outputs(8'h54);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Operation", test_num);
            reset_dut();


            @(posedge clk);
            load = 1; data_in = 8'h80;
            @(posedge clk);
            load = 0;


            @(posedge clk);
            shift_direction = 2'b10;
            @(posedge clk);
            shift_direction = 2'b00;

            @(posedge clk);
            read_en = 0;

            @(posedge clk);
            #2 #1;
 check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RAM Read Disabled", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 8'h10; write_data = 4'hF;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            load = 1; data_in = 8'hAA;
            @(posedge clk);
            load = 0;


            @(posedge clk);
            read_en = 0; read_addr = 8'h10;

            @(posedge clk);
            #2 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Address Boundary", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 8'hFF; write_data = 4'h5;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            load = 1; data_in = 8'h0F;
            @(posedge clk);
            load = 0;


            @(posedge clk);
            read_en = 1; read_addr = 8'hFF;

            @(posedge clk);
            #2 #1;
 check_outputs(8'h0A);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, read_addr, read_en, reset, shift_direction, write_addr, write_data, write_en, data_out);
    end

endmodule
