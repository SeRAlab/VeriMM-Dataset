`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] mem_addr;
    reg [2:0] opcode;
    reg read_en;
    reg reset;
    reg [7:0] write_data_M;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_addr(mem_addr),
        .opcode(opcode),
        .read_en(read_en),
        .reset(reset),
        .write_data_M(write_data_M),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clk = 0;
            mem_addr = 0;
            write_data_M = 0;
            write_en = 0;
            read_en = 0;
            opcode = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            mem_addr = 8'h05;
            opcode = 3'b000;
            read_en = 1;
            @(posedge clk);
            #2;
            $display("Testcase 001: Reset Check");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            mem_addr = 8'd10;
            write_data_M = 8'hA5;
            write_en = 1;
            opcode = 3'b001;
            @(posedge clk);
            #2;
            write_en = 0;

            read_en = 1;
            @(posedge clk);
            #2;
            $display("Testcase 002: Basic Write/Read");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            mem_addr = 8'd20;
            write_data_M = 8'hFF;
            write_en = 0;
            opcode = 3'b001;
            @(posedge clk);
            #2;

            read_en = 1;
            @(posedge clk);
            #2;
            $display("Testcase 003: Write Enable Check");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            mem_addr = 8'd30;
            write_data_M = 8'h55;
            write_en = 1;
            opcode = 3'b010;
            @(posedge clk);
            #2;
            write_en = 0;

            read_en = 0;
            @(posedge clk);
            #2;
            $display("Testcase 004: Read Enable Check (Expected 0 when read_en=0)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            mem_addr = 8'd63;
            write_data_M = 8'hDB;
            write_en = 1;
            opcode = 3'b111;
            @(posedge clk);
            #2;
            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #2;
            $display("Testcase 005: Boundary Address Check");
            #1;

            check_outputs(8'hDB);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            mem_addr = 8'd1; write_data_M = 8'h11; write_en = 1; opcode = 3'b001;
            @(posedge clk); #2;

            mem_addr = 8'd2; write_data_M = 8'h22;
            @(posedge clk); #2;
            write_en = 0;

            mem_addr = 8'd1; read_en = 1;
            @(posedge clk); #2;
            $display("Testcase 006: Sequence Check Addr 1");
            #1;

            check_outputs(8'h11);
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, mem_addr, opcode, read_en, reset, write_data_M, write_en, read_data);
    end

endmodule
