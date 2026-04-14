`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg read_en;
    reg reset;
    reg [31:0] write_data;
    reg write_en;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .read_en(read_en),
        .reset(reset),
        .write_data(write_data),
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
            read_en = 0;
            write_en = 0;
            address = 0;
            write_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h00000010;
            write_data = 32'hDEADBEEF;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            address = 32'h00000010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple addresses", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h000000A0;
            write_data = 32'h12345678;
            write_en = 1;
            @(posedge clk);


            address = 32'h000000B0;
            write_data = 32'h87654321;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            address = 32'h000000A0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Memory Overwrite", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h00000100;
            write_data = 32'hAAAA_AAAA;
            write_en = 1;
            @(posedge clk);


            write_data = 32'hBBBB_BBBB;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            address = 32'h00000100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High address boundary", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'hFFFFFFF0;
            write_data = 32'h55AA55AA;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            address = 32'hFFFFFFF0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
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
        input [31:0] expected_read_data;
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
        $dumpvars(0,address, clk, read_en, reset, write_data, write_en, read_data);
    end

endmodule
