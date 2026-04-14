`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl;
    reg [7:0] data_in;
    reg write_en;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
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
            $display("Resetting DUT...");
            ctrl = 4'b0000;
            data_in = 8'h00;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write/Read Reg 0");
            reset_dut();
            test_num = test_num + 1;


            ctrl = 4'b00_00;
            data_in = 8'hA3;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Write/Read Reg 3");
            reset_dut();
            test_num = test_num + 1;


            ctrl = 4'b11_11;
            data_in = 8'hC2;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Multi-register Independence");
            reset_dut();
            test_num = test_num + 1;


            ctrl = 4'b01_00;
            data_in = 8'h01;
            write_en = 1;
            @(posedge clk);
            #1;


            ctrl = 4'b10_00;
            data_in = 8'h02;
            write_en = 1;
            @(posedge clk);
            #1;


            write_en = 0;
            ctrl = 4'b00_01;
            #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Write Enable Check");
            reset_dut();
            test_num = test_num + 1;


            ctrl = 4'b00_00;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1;


            data_in = 8'h00;
            write_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Read Address Switching");
            reset_dut();
            test_num = test_num + 1;


            ctrl = 4'b00_00; data_in = 8'h01; write_en = 1;
            @(posedge clk); #1;


            ctrl = 4'b01_00; data_in = 8'h02; write_en = 1;
            @(posedge clk); #1;

            write_en = 0;


            ctrl = 4'b00_01;
            #1;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_data_out;
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
        $dumpvars(0,clk, ctrl, data_in, write_en, data_out);
    end

endmodule
