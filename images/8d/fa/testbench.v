`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [15:0] data_in;
    reg read;
    reg write;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            read = 0;
            write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Write 0xABCD to address 0x10 and read it back");
            reset_dut();


            address = 8'h10;
            data_in = 16'hABCD;
            write = 1;
            read = 0;
            @(posedge clk);
            #1;


            write = 0;
            read = 1;
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Ensure output is 0 when read is inactive");
            reset_dut();


            address = 8'h20;
            data_in = 16'h5555;
            write = 1;
            read = 0;
            @(posedge clk);
            #1;


            write = 0;
            read = 0;
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Overwrite data at address 0xFF");
            reset_dut();


            address = 8'hFF;
            data_in = 16'h1111;
            write = 1;
            @(posedge clk);
            #1;


            data_in = 16'h2222;
            @(posedge clk);
            #1;


            write = 0;
            read = 1;
            #2;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Write to two addresses and check one doesn't affect the other");
            reset_dut();


            address = 8'h01;
            data_in = 16'hAAAA;
            write = 1;
            @(posedge clk);
            #1;


            address = 8'h02;
            data_in = 16'hBBBB;
            @(posedge clk);
            #1;


            address = 8'h01;
            write = 0;
            read = 1;
            #2;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Test boundary address 0x00 and max data 0xFFFF");
            reset_dut();

            address = 8'h00;
            data_in = 16'hFFFF;
            write = 1;
            @(posedge clk);
            #1;

            write = 0;
            read = 1;
            #2;

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, read, write, data_out);
    end

endmodule
