`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr1;
    reg [2:0] addr2;
    reg clk;
    reg [7:0] data_in;
    reg write_en;
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
        .data_in(data_in),
        .write_en(write_en),
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
            addr1 = 0;
            addr2 = 0;
            data_in = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task write_reg;

        input [2:0] addr;
        input [7:0] data;
        begin
            @(posedge clk);
            addr1 = addr;
            data_in = data;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Write/Read Reg 0");
            reset_dut();
            write_reg(3'd0, 8'hA5);
            addr1 = 3'd0;
            addr2 = 3'd0;
            #2;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write Reg 7 and verify Port 2");
            reset_dut();
            write_reg(3'd7, 8'h5A);
            addr1 = 3'd7;
            addr2 = 3'd7;
            #2;
            #1;

            check_outputs(8'h5A, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Dual Port Read");
            reset_dut();
            write_reg(3'd1, 8'h11);
            write_reg(3'd2, 8'h22);
            addr1 = 3'd1;
            addr2 = 3'd2;
            #2;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write Enable De-asserted Check");
            reset_dut();

            write_reg(3'd3, 8'hCC);

            @(posedge clk);
            addr1 = 3'd3;
            data_in = 8'hFF;
            write_en = 0;
            @(posedge clk);
            #1;
            addr1 = 3'd3;
            addr2 = 3'd3;
            #2;
            #1;

            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Overwrite Register Data");
            reset_dut();
            write_reg(3'd4, 8'h10);
            write_reg(3'd4, 8'h20);
            addr1 = 3'd4;
            addr2 = 3'd4;
            #2;
            #1;

            check_outputs(8'h20, 8'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Multiple Register Check");
            reset_dut();
            write_reg(3'd0, 8'h00);
            write_reg(3'd1, 8'h01);
            write_reg(3'd2, 8'h02);
            write_reg(3'd3, 8'h03);
            addr1 = 3'd1;
            addr2 = 3'd3;
            #2;
            #1;

            check_outputs(8'h01, 8'h03);
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
        $dumpvars(0,addr1, addr2, clk, data_in, write_en, data_out1, data_out2);
    end

endmodule
