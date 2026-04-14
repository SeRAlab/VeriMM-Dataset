`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clear_error;
    reg clk;
    reg reset;
    reg [23:0] rom_data;
    reg transfer_complete;
    wire auto_init_complete;
    wire auto_init_error;
    wire [23:0] data_out;
    wire [5:0] rom_address;
    wire transfer_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .clear_error(clear_error),
        .clk(clk),
        .reset(reset),
        .rom_data(rom_data),
        .transfer_complete(transfer_complete),
        .auto_init_complete(auto_init_complete),
        .auto_init_error(auto_init_error),
        .data_out(data_out),
        .rom_address(rom_address),
        .transfer_data(transfer_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            clear_error = 0;
            rom_data = 24'h0;
            transfer_complete = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 24'h0, 6'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rom_data = 24'hABCDEF;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 24'hABCDEF, 6'h00, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rom_data = 24'h112233;


            wait(transfer_data == 1);
            @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;


            transfer_complete = 1;
            @(posedge clk);
            transfer_complete = 0;


            #1;



            check_outputs(0, 0, 24'h112233, 6'h01, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();

            for(i=0; i<3; i=i+1) begin
                rom_data = 24'hA0A0A0 + i;
                wait(transfer_data == 1);
                @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
                transfer_complete = 1;
                @(posedge clk);
                transfer_complete = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(0, 0, 24'hA0A0A2, 6'h03, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();



            clear_error = 1;
            @(posedge clk);
            clear_error = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 24'h0, 6'h00, 0);
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
        input expected_auto_init_complete;
        input expected_auto_init_error;
        input [23:0] expected_data_out;
        input [5:0] expected_rom_address;
        input expected_transfer_data;
        begin
            if (expected_auto_init_complete === (expected_auto_init_complete ^ auto_init_complete ^ expected_auto_init_complete) &&
                expected_auto_init_error === (expected_auto_init_error ^ auto_init_error ^ expected_auto_init_error) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_rom_address === (expected_rom_address ^ rom_address ^ expected_rom_address) &&
                expected_transfer_data === (expected_transfer_data ^ transfer_data ^ expected_transfer_data)) begin
                $display("PASS");
                $display("  Outputs: auto_init_complete=%b, auto_init_error=%b, data_out=%h, rom_address=%h, transfer_data=%b",
                         auto_init_complete, auto_init_error, data_out, rom_address, transfer_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: auto_init_complete=%b, auto_init_error=%b, data_out=%h, rom_address=%h, transfer_data=%b",
                         expected_auto_init_complete, expected_auto_init_error, expected_data_out, expected_rom_address, expected_transfer_data);
                $display("  Got:      auto_init_complete=%b, auto_init_error=%b, data_out=%h, rom_address=%h, transfer_data=%b",
                         auto_init_complete, auto_init_error, data_out, rom_address, transfer_data);
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
        $dumpvars(0,ack, clear_error, clk, reset, rom_data, transfer_complete, auto_init_complete, auto_init_error, data_out, rom_address, transfer_data);
    end

endmodule
