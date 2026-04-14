`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] addr1;
    reg [23:0] addr2;
    reg clk;
    reg [31:0] data_in2;
    reg [31:0] dram_data_out;
    reg dram_data_out_valid;
    reg dram_write_complete;
    reg req_read1;
    reg req_read2;
    reg req_write2;
    wire [31:0] data1;
    wire [31:0] data_out2;
    wire data_valid1;
    wire data_valid2;
    wire [23:0] dram_addr;
    wire [31:0] dram_data_in;
    wire dram_req_read;
    wire dram_req_write;
    wire write_complete2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in2(data_in2),
        .dram_data_out(dram_data_out),
        .dram_data_out_valid(dram_data_out_valid),
        .dram_write_complete(dram_write_complete),
        .req_read1(req_read1),
        .req_read2(req_read2),
        .req_write2(req_write2),
        .data1(data1),
        .data_out2(data_out2),
        .data_valid1(data_valid1),
        .data_valid2(data_valid2),
        .dram_addr(dram_addr),
        .dram_data_in(dram_data_in),
        .dram_req_read(dram_req_read),
        .dram_req_write(dram_req_write),
        .write_complete2(write_complete2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr1 = 0;
            addr2 = 0;
            data_in2 = 0;
            dram_data_out = 0;
            dram_data_out_valid = 0;
            dram_write_complete = 0;
            req_read1 = 0;
            req_read2 = 0;
            req_write2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Device 1 Read Request");
            reset_dut();


            @(posedge clk);
            addr1 = 24'hABCDEF;
            req_read1 = 1;



            wait(dram_req_read == 1 && dram_addr == 24'hABCDEF);


            @(posedge clk);
            dram_data_out = 32'hDEADBEEF;
            dram_data_out_valid = 1;


            wait(data_valid1 == 1);
            #1;

            #1;


            check_outputs(
                32'hDEADBEEF,
                0,
                1,
                0,
                24'hABCDEF,
                0,
                1,
                0,
                0
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Device 2 Read Request");
            reset_dut();


            @(posedge clk);
            addr2 = 24'h123456;
            req_read2 = 1;


            wait(dram_req_read == 1 && dram_addr == 24'h123456);


            @(posedge clk);
            dram_data_out = 32'hCAFEBABE;
            dram_data_out_valid = 1;


            wait(data_valid2 == 1);
            #1;

            #1;


            check_outputs(
                0,
                32'hCAFEBABE,
                0,
                1,
                24'h123456,
                0,
                1,
                0,
                0
            );
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Device 2 Write Request");
            reset_dut();


            @(posedge clk);
            addr2 = 24'h555555;
            data_in2 = 32'hAAAA5555;
            req_write2 = 1;


            wait(dram_req_write == 1 && dram_addr == 24'h555555);


            @(posedge clk);
            dram_write_complete = 1;


            wait(write_complete2 == 1);
            #1;

            #1;


            check_outputs(
                0,
                0,
                0,
                0,
                24'h555555,
                32'hAAAA5555,
                0,
                1,
                1
            );
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Simultaneous Read Requests Arbitration");
            reset_dut();


            @(posedge clk);
            addr1 = 24'h111111;
            req_read1 = 1;
            addr2 = 24'h222222;
            req_read2 = 1;



            wait(dram_req_read == 1 && dram_addr == 24'h111111);
            @(posedge clk);
            dram_data_out = 32'h11111111;
            dram_data_out_valid = 1;
            wait(data_valid1 == 1);


            @(posedge clk);
            req_read1 = 0;
            dram_data_out_valid = 0;


            wait(dram_req_read == 1 && dram_addr == 24'h222222);
            @(posedge clk);
            dram_data_out = 32'h22222222;
            dram_data_out_valid = 1;
            wait(data_valid2 == 1);
            #1;

            #1;


            check_outputs(
                0,
                32'h22222222,
                0,
                1,
                24'h222222,
                0,
                1,
                0,
                0
            );
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Device 2 Read and Write Collision");
            reset_dut();


            @(posedge clk);
            addr2 = 24'h888888;
            data_in2 = 32'h88888888;
            req_read2 = 1;
            req_write2 = 1;


            wait(dram_req_read == 1 || dram_req_write == 1);


            if(dram_req_write) begin
                @(posedge clk);
                dram_write_complete = 1;
                wait(write_complete2 == 1);
            end else begin
                @(posedge clk);
                dram_data_out_valid = 1;
                wait(data_valid2 == 1);
            end

            #1;

            if (write_complete2 || data_valid2) begin
                pass_count = pass_count + 1;
                $display("PASS: Collision handled");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No request handled during collision");
            end
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
        input [31:0] expected_data1;
        input [31:0] expected_data_out2;
        input expected_data_valid1;
        input expected_data_valid2;
        input [23:0] expected_dram_addr;
        input [31:0] expected_dram_data_in;
        input expected_dram_req_read;
        input expected_dram_req_write;
        input expected_write_complete2;
        begin
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_data_valid1 === (expected_data_valid1 ^ data_valid1 ^ expected_data_valid1) &&
                expected_data_valid2 === (expected_data_valid2 ^ data_valid2 ^ expected_data_valid2) &&
                expected_dram_addr === (expected_dram_addr ^ dram_addr ^ expected_dram_addr) &&
                expected_dram_data_in === (expected_dram_data_in ^ dram_data_in ^ expected_dram_data_in) &&
                expected_dram_req_read === (expected_dram_req_read ^ dram_req_read ^ expected_dram_req_read) &&
                expected_dram_req_write === (expected_dram_req_write ^ dram_req_write ^ expected_dram_req_write) &&
                expected_write_complete2 === (expected_write_complete2 ^ write_complete2 ^ expected_write_complete2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data_out2=%h, data_valid1=%b, data_valid2=%b, dram_addr=%h, dram_data_in=%h, dram_req_read=%b, dram_req_write=%b, write_complete2=%b",
                         data1, data_out2, data_valid1, data_valid2, dram_addr, dram_data_in, dram_req_read, dram_req_write, write_complete2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data_out2=%h, data_valid1=%b, data_valid2=%b, dram_addr=%h, dram_data_in=%h, dram_req_read=%b, dram_req_write=%b, write_complete2=%b",
                         expected_data1, expected_data_out2, expected_data_valid1, expected_data_valid2, expected_dram_addr, expected_dram_data_in, expected_dram_req_read, expected_dram_req_write, expected_write_complete2);
                $display("  Got:      data1=%h, data_out2=%h, data_valid1=%b, data_valid2=%b, dram_addr=%h, dram_data_in=%h, dram_req_read=%b, dram_req_write=%b, write_complete2=%b",
                         data1, data_out2, data_valid1, data_valid2, dram_addr, dram_data_in, dram_req_read, dram_req_write, write_complete2);
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
        $dumpvars(0,addr1, addr2, clk, data_in2, dram_data_out, dram_data_out_valid, dram_write_complete, req_read1, req_read2, req_write2, data1, data_out2, data_valid1, data_valid2, dram_addr, dram_data_in, dram_req_read, dram_req_write, write_complete2);
    end

endmodule
