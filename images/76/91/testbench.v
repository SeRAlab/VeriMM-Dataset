`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr_0;
    reg [3:0] read_addr_1;
    reg [1:0] read_en_0;
    reg [1:0] read_en_1;
    reg rst_n;
    reg [3:0] write_addr_0;
    reg [3:0] write_addr_1;
    reg [15:0] write_data_0;
    reg [15:0] write_data_1;
    reg [1:0] write_en_0;
    reg [1:0] write_en_1;
    wire [15:0] read_data_0;
    wire [15:0] read_data_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr_0(read_addr_0),
        .read_addr_1(read_addr_1),
        .read_en_0(read_en_0),
        .read_en_1(read_en_1),
        .rst_n(rst_n),
        .write_addr_0(write_addr_0),
        .write_addr_1(write_addr_1),
        .write_data_0(write_data_0),
        .write_data_1(write_data_1),
        .write_en_0(write_en_0),
        .write_en_1(write_en_1),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            write_en_0 = 2'b00;
            write_en_1 = 2'b00;
            read_en_0 = 2'b00;
            read_en_1 = 2'b00;
            write_addr_0 = 4'h0;
            write_addr_1 = 4'h0;
            write_data_0 = 16'h0;
            write_data_1 = 16'h0;
            read_addr_0 = 4'h0;
            read_addr_1 = 4'h0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Reset Check");
            read_en_0 = 2'b11;
            read_addr_0 = 4'h5;
            read_en_1 = 2'b11;
            read_addr_1 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Port 0 Write/Read");
            @(posedge clk);
            write_en_0 = 2'b11;
            write_addr_0 = 4'hA;
            write_data_0 = 16'hABCD;
            @(posedge clk);
            write_en_0 = 2'b00;
            read_en_0 = 2'b11;
            read_addr_0 = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Port 1 Write/Read");
            @(posedge clk);
            write_en_1 = 2'b11;
            write_addr_1 = 4'h3;
            write_data_1 = 16'h55AA;
            @(posedge clk);
            write_en_1 = 2'b00;
            read_en_1 = 2'b11;
            read_addr_1 = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Dual Port Concurrent Writes");
            @(posedge clk);
            write_en_0 = 2'b11; write_addr_0 = 4'h1; write_data_0 = 16'h1111;
            write_en_1 = 2'b11; write_addr_1 = 4'h2; write_data_1 = 16'h2222;
            @(posedge clk);
            write_en_0 = 0; write_en_1 = 0;
            read_en_0 = 2'b11; read_addr_0 = 4'h1;
            read_en_1 = 2'b11; read_addr_1 = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Byte-level Write Enable");

            @(posedge clk);
            write_en_0 = 2'b11; write_addr_0 = 4'h5; write_data_0 = 16'hAAAA;
            @(posedge clk);

            write_en_0 = 2'b01; write_addr_0 = 4'h5; write_data_0 = 16'hZZ55;
            @(posedge clk);
            write_en_0 = 0;
            read_en_0 = 2'b11; read_addr_0 = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAA55, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Running Testcase 006: Read Enable Functionality");
            @(posedge clk);
            write_en_0 = 2'b11; write_addr_0 = 4'h8; write_data_0 = 16'hFFFF;
            @(posedge clk);
            write_en_0 = 0;

            read_en_0 = 2'b00; read_addr_0 = 4'h8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Running Testcase 007: Simultaneous Read and Write on different ports");

            @(posedge clk);
            write_en_0 = 2'b11; write_addr_0 = 4'h4; write_data_0 = 16'h4444;
            @(posedge clk);

            write_en_0 = 0;
            read_en_0 = 2'b11; read_addr_0 = 4'h4;
            write_en_1 = 2'b11; write_addr_1 = 4'hE; write_data_1 = 16'hEEEE;
            @(posedge clk);

            write_en_1 = 0;
            read_en_1 = 2'b11; read_addr_1 = 4'hE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4444, 16'hEEEE);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Running Testcase 008: Cross-Port Memory Persistence");
            @(posedge clk);
            write_en_0 = 2'b11; write_addr_0 = 4'hC; write_data_0 = 16'hC0DE;
            @(posedge clk);
            write_en_0 = 0;
            read_en_1 = 2'b11; read_addr_1 = 4'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'hC0DE);
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
        testcase008();
        
        
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
        input [15:0] expected_read_data_0;
        input [15:0] expected_read_data_1;
        begin
            if (expected_read_data_0 === (expected_read_data_0 ^ read_data_0 ^ expected_read_data_0) &&
                expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1)) begin
                $display("PASS");
                $display("  Outputs: read_data_0=%h, read_data_1=%h",
                         read_data_0, read_data_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_0=%h, read_data_1=%h",
                         expected_read_data_0, expected_read_data_1);
                $display("  Got:      read_data_0=%h, read_data_1=%h",
                         read_data_0, read_data_1);
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
        $dumpvars(0,clk, read_addr_0, read_addr_1, read_en_0, read_en_1, rst_n, write_addr_0, write_addr_1, write_data_0, write_data_1, write_en_0, write_en_1, read_data_0, read_data_1);
    end

endmodule
