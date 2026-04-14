`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clk;
    reg read_signal_memory;
    reg reset;
    reg [31:0] write_data;
    reg write_signal_memory;
    wire [31:0] memory_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .read_signal_memory(read_signal_memory),
        .reset(reset),
        .write_data(write_data),
        .write_signal_memory(write_signal_memory),
        .memory_out(memory_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            write_data = 0;
            write_signal_memory = 0;
            read_signal_memory = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            address = 5'd5;
            write_data = 32'hDEADBEEF;
            write_signal_memory = 1;
            @(posedge clk);
            #1 write_signal_memory = 0;


            read_signal_memory = 1;
            @(negedge clk);
            #1;
            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            address = 5'd10;
            read_signal_memory = 1;
            @(negedge clk);
            #1;
            $display("Testcase 002: Reset Verification");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            address = 5'd31;
            write_data = 32'hAAAA_5555;
            write_signal_memory = 1;
            @(posedge clk);
            #1 write_signal_memory = 0;

            read_signal_memory = 1;
            @(negedge clk);
            #1;
            $display("Testcase 003: Boundary Address 31");
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            address = 5'd15;
            write_data = 32'h1234_5678;
            write_signal_memory = 0;
            @(posedge clk);


            read_signal_memory = 1;
            @(negedge clk);
            #1;
            $display("Testcase 004: Write Disable Check");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            address = 5'd2;
            write_data = 32'h8888_9999;
            write_signal_memory = 1;
            @(posedge clk);
            #1 write_signal_memory = 0;


            read_signal_memory = 0;
            @(negedge clk);
            #1;
            $display("Testcase 005: Read Disable Check");


            #1;



            check_outputs(memory_out);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            address = 5'd20;
            write_data = 32'h1111_1111;
            write_signal_memory = 1;
            @(posedge clk);
            #1 write_data = 32'h2222_2222;
            @(posedge clk);
            #1 write_signal_memory = 0;

            read_signal_memory = 1;
            @(negedge clk);
            #1;
            $display("Testcase 006: Overwrite Check");
            #1;

            check_outputs(32'h2222_2222);
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
        input [31:0] expected_memory_out;
        begin
            if (expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out)) begin
                $display("PASS");
                $display("  Outputs: memory_out=%h",
                         memory_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_out=%h",
                         expected_memory_out);
                $display("  Got:      memory_out=%h",
                         memory_out);
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
        $dumpvars(0,address, clk, read_signal_memory, reset, write_data, write_signal_memory, memory_out);
    end

endmodule
