`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [2:0] read_addr;
    reg we;
    reg [2:0] write_addr;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            data = 8'h00;
            write_addr = 3'h0;
            read_addr = 3'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd0; data = 8'hA5;
            @(posedge clk);

            we = 0; read_addr = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Write/Read Reg 0");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd7; data = 8'h5A;
            @(posedge clk);

            we = 0; read_addr = 3'd7;
            @(posedge clk);
            #1;
            $display("Testcase 002: Write/Read Reg 7");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd2; data = 8'h11;
            @(posedge clk);

            we = 0; write_addr = 3'd2; data = 8'hEE;
            @(posedge clk);

            read_addr = 3'd2;
            @(posedge clk);
            #1;
            $display("Testcase 003: Write Enable (we=0) check");
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd4; data = 8'h33;
            @(posedge clk);

            we = 1; write_addr = 3'd4; data = 8'h44;
            @(posedge clk);

            we = 0; read_addr = 3'd4;
            @(posedge clk);
            #1;
            $display("Testcase 004: Overwrite Reg 4");
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd1; data = 8'hBB;
            @(posedge clk);

            we = 1; write_addr = 3'd6; data = 8'hCC; read_addr = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase 005: Read while writing different addr");
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            we = 1; write_addr = 3'd5; data = 8'h99;
            @(posedge clk);

            we = 0; read_addr = 3'd5;
            #1;


            @(posedge clk);
            #1;
            $display("Testcase 006: Sync Read check");
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, read_addr, we, write_addr, q);
    end

endmodule
