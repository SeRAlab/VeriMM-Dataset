`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [23:0] stream_in_data;
    reg [1:0] stream_in_empty;
    reg stream_in_endofpacket;
    reg stream_in_startofpacket;
    reg stream_in_valid;
    reg stream_out_ready;
    wire stream_in_ready;
    wire [15:0] stream_out_data;
    wire stream_out_empty;
    wire stream_out_endofpacket;
    wire stream_out_startofpacket;
    wire stream_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .stream_in_data(stream_in_data),
        .stream_in_empty(stream_in_empty),
        .stream_in_endofpacket(stream_in_endofpacket),
        .stream_in_startofpacket(stream_in_startofpacket),
        .stream_in_valid(stream_in_valid),
        .stream_out_ready(stream_out_ready),
        .stream_in_ready(stream_in_ready),
        .stream_out_data(stream_out_data),
        .stream_out_empty(stream_out_empty),
        .stream_out_endofpacket(stream_out_endofpacket),
        .stream_out_startofpacket(stream_out_startofpacket),
        .stream_out_valid(stream_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stream_in_data = 24'b0;
            stream_in_empty = 2'b0;
            stream_in_endofpacket = 1'b0;
            stream_in_startofpacket = 1'b0;
            stream_in_valid = 1'b0;
            stream_out_ready = 1'b1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1, 16'h0000, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full White Color (24'hFFFFFF) and SOP Propagation", test_num);
            reset_dut();
            stream_in_data = 24'hFFFFFF;
            stream_in_valid = 1'b1;
            stream_in_startofpacket = 1'b1;
            stream_in_endofpacket = 1'b0;
            stream_in_empty = 2'b00;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 16'h7FFF, 0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Black Color (24'h000000) and EOP Propagation", test_num);
            reset_dut();
            stream_in_data = 24'h000000;
            stream_in_valid = 1'b1;
            stream_in_startofpacket = 1'b0;
            stream_in_endofpacket = 1'b1;
            stream_in_empty = 2'b00;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 16'h0000, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Scaling Check (24'h808080)", test_num);
            reset_dut();
            stream_in_data = 24'h808080;
            stream_in_valid = 1'b1;
            stream_in_startofpacket = 1'b0;
            stream_in_endofpacket = 1'b0;
            stream_in_empty = 2'b00;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 16'h4210, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Color (24'h123456) and Flow Control", test_num);
            reset_dut();


            stream_in_data = 24'h123456;





            stream_in_valid = 1'b1;
            stream_out_ready = 1'b0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 16'h08CA, 0, 0, 0, 1);


            stream_out_ready = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 16'h08CA, 0, 0, 0, 1);
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
        input expected_stream_in_ready;
        input [15:0] expected_stream_out_data;
        input expected_stream_out_empty;
        input expected_stream_out_endofpacket;
        input expected_stream_out_startofpacket;
        input expected_stream_out_valid;
        begin
            if (expected_stream_in_ready === (expected_stream_in_ready ^ stream_in_ready ^ expected_stream_in_ready) &&
                expected_stream_out_data === (expected_stream_out_data ^ stream_out_data ^ expected_stream_out_data) &&
                expected_stream_out_empty === (expected_stream_out_empty ^ stream_out_empty ^ expected_stream_out_empty) &&
                expected_stream_out_endofpacket === (expected_stream_out_endofpacket ^ stream_out_endofpacket ^ expected_stream_out_endofpacket) &&
                expected_stream_out_startofpacket === (expected_stream_out_startofpacket ^ stream_out_startofpacket ^ expected_stream_out_startofpacket) &&
                expected_stream_out_valid === (expected_stream_out_valid ^ stream_out_valid ^ expected_stream_out_valid)) begin
                $display("PASS");
                $display("  Outputs: stream_in_ready=%b, stream_out_data=%h, stream_out_empty=%b, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         stream_in_ready, stream_out_data, stream_out_empty, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stream_in_ready=%b, stream_out_data=%h, stream_out_empty=%b, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         expected_stream_in_ready, expected_stream_out_data, expected_stream_out_empty, expected_stream_out_endofpacket, expected_stream_out_startofpacket, expected_stream_out_valid);
                $display("  Got:      stream_in_ready=%b, stream_out_data=%h, stream_out_empty=%b, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         stream_in_ready, stream_out_data, stream_out_empty, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
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
        $dumpvars(0,clk, reset, stream_in_data, stream_in_empty, stream_in_endofpacket, stream_in_startofpacket, stream_in_valid, stream_out_ready, stream_in_ready, stream_out_data, stream_out_empty, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
    end

endmodule
