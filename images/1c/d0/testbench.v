`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_size;
    reg [15:0] dest_addr;
    reg rst;
    reg [15:0] src_addr;
    reg start;
    wire [15:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_size(data_size),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            data_size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Transfer");
            reset_dut();
            src_addr = 16'h1000;
            dest_addr = 16'h2000;
            data_size = 8'h10;
            start = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1000, 1'b1);
            start = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Maximum Data Size");
            reset_dut();
            src_addr = 16'hAAAA;
            dest_addr = 16'h5555;
            data_size = 8'hFF;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA, 1'b1);
            start = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Idle State (No Start)");
            reset_dut();
            src_addr = 16'h1234;
            dest_addr = 16'h5678;
            data_size = 8'h05;
            start = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Zero Data Size");
            reset_dut();
            src_addr = 16'h1111;
            dest_addr = 16'h2222;
            data_size = 8'h00;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1111, 1'b1);
            start = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive Transfers");
            reset_dut();


            src_addr = 16'h1010;
            dest_addr = 16'h2020;
            data_size = 8'h04;
            start = 1;
            @(posedge clk);
            #2;


            src_addr = 16'h3030;
            dest_addr = 16'h4040;
            data_size = 8'h08;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h3030, 1'b1);
            start = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_size, dest_addr, rst, src_addr, start, data_out, done);
    end

endmodule
