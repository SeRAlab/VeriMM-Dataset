`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] count;
    reg [7:0] data_in;
    reg start;
    wire [10:0] address;
    wire [3:0] data_out;
    wire done;
    wire enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count(count),
        .data_in(data_in),
        .start(start),
        .address(address),
        .data_out(data_out),
        .done(done),
        .enable(enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            count = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Byte Transmission (0xA5)", test_num);
            reset_dut();

            count = 11'd1;
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(11'd0, 4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 3-Byte Transmission", test_num);
            reset_dut();

            count = 11'd3;
            data_in = 8'h12;
            start = 1;
            @(posedge clk);
            #1 start = 0;



            repeat(6) begin
                @(posedge clk);
                #1;
                if (address == 1) data_in = 8'h34;
                if (address == 2) data_in = 8'h56;
            end


            @(posedge clk);
            #1;


            #1;



            check_outputs(11'd2, 4'h5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Done Signal Reset on Restart", test_num);

            reset_dut();
            count = 11'd1;
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(3) @(posedge clk);
            #1;


            start = 1;
            count = 11'd2;
            @(posedge clk);
            #1;

            if (done === 1'b0) begin
                $display("PASS: Done signal reset successfully.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Done signal did not reset on new start.");
                fail_count = fail_count + 1;
            end
            start = 0;


            repeat(5) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Immediate Address and Enable Check", test_num);
            reset_dut();
            count = 11'd5;
            data_in = 8'hCC;
            start = 1;
            @(posedge clk);
            #1;

            if (enable === 1'b1 && address === 11'd0) begin
                $display("PASS: Initial transmission state correct.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Initial transmission state incorrect (enable=%b, addr=%h).", enable, address);
                fail_count = fail_count + 1;
            end


            start = 0;
            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd4, 4'hC, 1'b1, 1'b0);
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
        input [10:0] expected_address;
        input [3:0] expected_data_out;
        input expected_done;
        input expected_enable;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable)) begin
                $display("PASS");
                $display("  Outputs: address=%h, data_out=%h, done=%b, enable=%b",
                         address, data_out, done, enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, data_out=%h, done=%b, enable=%b",
                         expected_address, expected_data_out, expected_done, expected_enable);
                $display("  Got:      address=%h, data_out=%h, done=%b, enable=%b",
                         address, data_out, done, enable);
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
        $dumpvars(0,clk, count, data_in, start, address, data_out, done, enable);
    end

endmodule
