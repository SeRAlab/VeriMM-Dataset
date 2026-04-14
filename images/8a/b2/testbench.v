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
            stream_data = 0;
            stream_startofpacket = 0;
            stream_endofpacket = 0;
            stream_empty = 0;
            stream_valid = 0;
            master_waitrequest = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Valid Transfer", test_num);
            reset_dut();

            stream_data = 16'hABCD;
            stream_valid = 1;
            stream_startofpacket = 0;
            master_waitrequest = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1, 16'hABCD, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Master Waitrequest Stall", test_num);
            reset_dut();

            stream_data = 16'h1234;
            stream_valid = 1;
            master_waitrequest = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 16'h1234, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start of Packet Trigger", test_num);
            reset_dut();

            stream_data = 16'h55AA;
            stream_valid = 1;
            stream_startofpacket = 1;
            master_waitrequest = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1, 16'h55AA, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Stream Data", test_num);
            reset_dut();

            stream_data = 16'hDEAD;
            stream_valid = 0;
            master_waitrequest = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 16'hDEAD, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: End of Packet Transfer", test_num);
            reset_dut();

            stream_data = 16'hEEEE;
            stream_valid = 1;
            stream_endofpacket = 1;
            master_waitrequest = 0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 1'b1, 16'hEEEE, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SOP with Waitrequest", test_num);
            reset_dut();

            stream_data = 16'hF0F0;
            stream_valid = 1;
            stream_startofpacket = 1;
            master_waitrequest = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 16'hF0F0, 1'b0, 1'b0);
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
