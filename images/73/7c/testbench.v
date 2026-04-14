`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [7:0] addr_wr;
    reg clk;
    reg [31:0] data_in;
    reg write;
    wire [31:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .addr_wr(addr_wr),
        .clk(clk),
        .data_in(data_in),
        .write(write),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            addr_wr = 0;
            data_in = 0;
            write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic Write and Read back");


            @(negedge clk);
            addr_wr = 8'h10;
            data_in = 32'hDEADBEEF;
            write = 1;

            @(posedge clk);
            #1;
            write = 0;
            addr = 8'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Write to Boundary Address (0xFF)");

            @(negedge clk);
            addr_wr = 8'hFF;
            data_in = 32'hAAAA5555;
            write = 1;

            @(posedge clk);
            #1;
            write = 0;
            addr = 8'hFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Write to Address 0x00");

            @(negedge clk);
            addr_wr = 8'h00;
            data_in = 32'h1234ABCD;
            write = 1;

            @(posedge clk);
            #1;
            write = 0;
            addr = 8'h00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1234ABCD);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Ensure write signal is respected");


            @(negedge clk);
            addr_wr = 8'h20;
            data_in = 32'h77777777;
            write = 1;
            @(posedge clk);


            @(negedge clk);
            addr_wr = 8'h20;
            data_in = 32'hEEEEEEEE;
            write = 0;
            @(posedge clk);


            #1;
            addr = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h77777777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Simultaneous Write and Read (different addrs)");


            @(negedge clk);
            addr_wr = 8'h50;
            data_in = 32'hCAFEFACE;
            write = 1;
            @(posedge clk);


            @(negedge clk);
            addr_wr = 8'h60;
            data_in = 32'hBBBBBBBB;
            write = 1;
            addr = 8'h50;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEFACE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Multiple consecutive writes");

            @(negedge clk);
            write = 1;
            addr_wr = 8'h01; data_in = 32'h00000001;
            @(posedge clk);

            @(negedge clk);
            addr_wr = 8'h02; data_in = 32'h00000002;
            @(posedge clk);

            @(negedge clk);
            addr_wr = 8'h03; data_in = 32'h00000003;
            @(posedge clk);

            #1;
            write = 0;
            addr = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000002);
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
        input [31:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,addr, addr_wr, clk, data_in, write, data);
    end

endmodule
