`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
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
            rst_n = 0;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read to Bank 0", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 4'h2;
            write_data = 8'hA5;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1;
            read_addr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read to Bank 1", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 4'hC;
            write_data = 8'h5A;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1;
            read_addr = 4'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 4'h5;
            write_data = 8'h11;
            @(posedge clk);
            #1;


            write_en = 1;
            write_addr = 4'h9;
            write_data = 8'h22;
            read_en = 1;
            read_addr = 4'h5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Enable gate check", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 4'h7;
            write_data = 8'hFF;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 0;
            read_addr = 4'h7;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset initialization check", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
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
        $dumpvars(0,clk, read_addr, read_en, rst_n, write_addr, write_data, write_en, read_data);
    end

endmodule
