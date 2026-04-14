`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] read_data;

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
            read_en = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Single Write and Read", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 8'h05;
            write_data = 4'hA;
            @(posedge clk);


            #1;
            write_en = 0;
            read_en = 1;
            read_addr = 8'h05;
            @(posedge clk);

            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Concurrent Read and Write (Different Addr)", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 8'h10;
            write_data = 4'h7;
            @(posedge clk);


            #1;
            write_en = 1;
            write_addr = 8'h20;
            write_data = 4'hE;
            read_en = 1;
            read_addr = 8'h10;
            @(posedge clk);

            #1 #1;
 check_outputs(4'h7);


            #1;
            write_en = 0;
            read_en = 1;
            read_addr = 8'h20;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Read and Write (Same Addr)", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 8'hFF;
            write_data = 4'h1;
            @(posedge clk);


            #1;
            write_en = 1;
            write_addr = 8'hFF;
            write_data = 4'h2;
            read_en = 1;
            read_addr = 8'hFF;
            @(posedge clk);


            #1 #1;
 check_outputs(4'h1);


            @(posedge clk);
            #1 #1;
 check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Signals Verification", test_num);
            reset_dut();


            write_en = 0;
            write_addr = 8'h55;
            write_data = 4'hF;
            @(posedge clk);


            #1;
            read_en = 1;
            read_addr = 8'h55;
            @(posedge clk);


            if (read_data === 4'hF) begin
                $display("FAIL: Write occurred even when write_en was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Write inhibited by write_en=0");
                pass_count = pass_count + 1;
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
        input [3:0] expected_read_data;
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
