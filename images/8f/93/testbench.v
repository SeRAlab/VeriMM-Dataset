`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_in_0;
    reg [3:0] addr_in_1;
    reg clk;
    reg [7:0] data_in;
    reg port_en_0;
    reg port_en_1;
    reg wr_en;
    wire [7:0] data_out_0;
    wire [7:0] data_out_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in_0(addr_in_0),
        .addr_in_1(addr_in_1),
        .clk(clk),
        .data_in(data_in),
        .port_en_0(port_en_0),
        .port_en_1(port_en_1),
        .wr_en(wr_en),
        .data_out_0(data_out_0),
        .data_out_1(data_out_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            port_en_0 = 0;
            port_en_1 = 0;
            wr_en = 0;
            addr_in_0 = 0;
            addr_in_1 = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write and Read Port 0");
            reset_dut();

            port_en_0 = 1;
            wr_en = 1;
            addr_in_0 = 4'h4;
            data_in = 8'hA5;
            @(posedge clk);
            #1;

            wr_en = 0;
            addr_in_0 = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Port 0, Read Port 1");
            reset_dut();

            port_en_0 = 1;
            wr_en = 1;
            addr_in_0 = 4'hA;
            data_in = 8'h5A;
            @(posedge clk);
            #1;

            port_en_0 = 0;
            wr_en = 0;
            port_en_1 = 1;
            addr_in_1 = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Dual Port Read");
            reset_dut();

            port_en_0 = 1; wr_en = 1; addr_in_0 = 4'h1; data_in = 8'h11; @(posedge clk); #1;
            port_en_0 = 1; wr_en = 1; addr_in_0 = 4'h2; data_in = 8'h22; @(posedge clk); #1;

            wr_en = 0;
            port_en_0 = 1; addr_in_0 = 4'h1;
            port_en_1 = 1; addr_in_1 = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Protection (port_en_0=0)");
            reset_dut();

            port_en_0 = 0;
            wr_en = 1;
            addr_in_0 = 4'h5;
            data_in = 8'hFF;
            @(posedge clk);
            #1;

            port_en_0 = 1;
            wr_en = 0;
            addr_in_0 = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Independent Address Lines Check");
            reset_dut();

            port_en_0 = 1; wr_en = 1; addr_in_0 = 4'hF; data_in = 8'hCC; @(posedge clk); #1;

            wr_en = 0;
            port_en_0 = 1; addr_in_0 = 4'h0;
            port_en_1 = 1; addr_in_1 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hCC);
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
        input [7:0] expected_data_out_0;
        input [7:0] expected_data_out_1;
        begin
            if (expected_data_out_0 === (expected_data_out_0 ^ data_out_0 ^ expected_data_out_0) &&
                expected_data_out_1 === (expected_data_out_1 ^ data_out_1 ^ expected_data_out_1)) begin
                $display("PASS");
                $display("  Outputs: data_out_0=%h, data_out_1=%h",
                         data_out_0, data_out_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_0=%h, data_out_1=%h",
                         expected_data_out_0, expected_data_out_1);
                $display("  Got:      data_out_0=%h, data_out_1=%h",
                         data_out_0, data_out_1);
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
        $dumpvars(0,addr_in_0, addr_in_1, clk, data_in, port_en_0, port_en_1, wr_en, data_out_0, data_out_1);
    end

endmodule
