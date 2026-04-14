`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg master_waitrequest;
    reg reset;
    reg [15:0] stream_data;
    reg stream_empty;
    reg stream_endofpacket;
    reg stream_startofpacket;
    reg stream_valid;
    wire inc_address;
    wire master_write;
    wire [15:0] master_writedata;
    wire reset_address;
    wire stream_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .master_waitrequest(master_waitrequest),
        .reset(reset),
        .stream_data(stream_data),
        .stream_empty(stream_empty),
        .stream_endofpacket(stream_endofpacket),
        .stream_startofpacket(stream_startofpacket),
        .stream_valid(stream_valid),
        .inc_address(inc_address),
        .master_write(master_write),
        .master_writedata(master_writedata),
        .reset_address(reset_address),
        .stream_ready(stream_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            master_waitrequest = 0;
            stream_data = 0;
            stream_empty = 0;
            stream_endofpacket = 0;
            stream_startofpacket = 0;
            stream_valid = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset and Idle Check");
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: SOP Check (Handshake successful)");
            reset_dut();
            @(posedge clk);
            stream_valid = 1;
            stream_startofpacket = 1;
            stream_data = 16'hAAAA;
            master_waitrequest = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 16'hAAAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Mid-packet Data Check");
            reset_dut();
            @(posedge clk);
            stream_valid = 1;
            stream_startofpacket = 0;
            stream_endofpacket = 0;
            stream_data = 16'h5555;
            master_waitrequest = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 16'h5555, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Master Waitrequest Stall Check");
            reset_dut();
            @(posedge clk);
            stream_valid = 1;
            stream_data = 16'hBEEF;
            master_waitrequest = 1;
            #1;



            #1;




            check_outputs(1'b0, 1'b1, 16'hBEEF, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: EOP Check");
            reset_dut();
            @(posedge clk);
            stream_valid = 1;
            stream_endofpacket = 1;
            stream_data = 16'hE00D;
            master_waitrequest = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 16'hE00D, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Stream Invalid Check");
            reset_dut();
            @(posedge clk);
            stream_valid = 0;
            stream_data = 16'h1234;
            master_waitrequest = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 16'h1234, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: SOP with Waitrequest Stall");
            reset_dut();
            @(posedge clk);
            stream_valid = 1;
            stream_startofpacket = 1;
            stream_data = 16'hF00D;
            master_waitrequest = 1;
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 16'hF00D, 1'b1, 1'b0);
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
        input expected_inc_address;
        input expected_master_write;
        input [15:0] expected_master_writedata;
        input expected_reset_address;
        input expected_stream_ready;
        begin
            if (expected_inc_address === (expected_inc_address ^ inc_address ^ expected_inc_address) &&
                expected_master_write === (expected_master_write ^ master_write ^ expected_master_write) &&
                expected_master_writedata === (expected_master_writedata ^ master_writedata ^ expected_master_writedata) &&
                expected_reset_address === (expected_reset_address ^ reset_address ^ expected_reset_address) &&
                expected_stream_ready === (expected_stream_ready ^ stream_ready ^ expected_stream_ready)) begin
                $display("PASS");
                $display("  Outputs: inc_address=%b, master_write=%b, master_writedata=%h, reset_address=%b, stream_ready=%b",
                         inc_address, master_write, master_writedata, reset_address, stream_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inc_address=%b, master_write=%b, master_writedata=%h, reset_address=%b, stream_ready=%b",
                         expected_inc_address, expected_master_write, expected_master_writedata, expected_reset_address, expected_stream_ready);
                $display("  Got:      inc_address=%b, master_write=%b, master_writedata=%h, reset_address=%b, stream_ready=%b",
                         inc_address, master_write, master_writedata, reset_address, stream_ready);
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
        $dumpvars(0,clk, master_waitrequest, reset, stream_data, stream_empty, stream_endofpacket, stream_startofpacket, stream_valid, inc_address, master_write, master_writedata, reset_address, stream_ready);
    end

endmodule
