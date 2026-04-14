`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr1;
    reg [3:0] addr2;
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg wr_en1;
    reg wr_en2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .wr_en1(wr_en1),
        .wr_en2(wr_en2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en1 = 0;
            wr_en2 = 0;
            addr1 = 0;
            addr2 = 0;
            data_in1 = 0;
            data_in2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Concurrent write to unique addresses");
            reset_dut();
            @(posedge clk);
            wr_en1 = 1;
            wr_en2 = 1;
            addr1 = 4'h5;
            addr2 = 4'hA;
            data_in1 = 8'hAA;
            data_in2 = 8'h55;
            @(posedge clk);
            wr_en1 = 0;
            wr_en2 = 0;
            #1;
            #1;

            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Port 1, Read Port 2 (Sharing)");
            reset_dut();
            @(posedge clk);
            wr_en1 = 1;
            addr1 = 4'h7;
            data_in1 = 8'hBC;
            @(posedge clk);
            wr_en1 = 0;
            addr2 = 4'h7;
            #1;
            #1;

            check_outputs(8'h00, 8'hBC);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Gating Test");
            reset_dut();

            @(posedge clk);
            wr_en1 = 0;
            addr1 = 4'h3;
            data_in1 = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary Addresses (0 and 15)");
            reset_dut();
            @(posedge clk);
            wr_en1 = 1;
            wr_en2 = 1;
            addr1 = 4'd0;
            addr2 = 4'd15;
            data_in1 = 8'h11;
            data_in2 = 8'hEE;
            @(posedge clk);
            wr_en1 = 0;
            wr_en2 = 0;
            #1;
            #1;

            check_outputs(8'h11, 8'hEE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite check");
            reset_dut();

            @(posedge clk);
            wr_en1 = 1;
            addr1 = 4'h8;
            data_in1 = 8'h12;
            @(posedge clk);

            data_in1 = 8'h34;
            @(posedge clk);
            wr_en1 = 0;
            #1;
            #1;

            check_outputs(8'h34, 8'h00);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
        $dumpvars(0,addr1, addr2, clk, data_in1, data_in2, wr_en1, wr_en2, data_out1, data_out2);
    end

endmodule
