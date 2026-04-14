`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read Addr 0", test_num);


            @(posedge clk);
            addr <= 13'h0000;
            data_in <= 16'hAAAA;
            wr_en <= 1'b1;

            @(posedge clk);
            wr_en <= 1'b0;


            addr <= 13'h0000;
            rd_en <= 1'b1;

            @(posedge clk);
            rd_en <= 1'b0;

            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Max Address Bound Check (8191)", test_num);

            @(posedge clk);
            addr <= 13'd8191;
            data_in <= 16'h5555;
            wr_en <= 1'b1;

            @(posedge clk);
            wr_en <= 1'b0;
            addr <= 13'd8191;
            rd_en <= 1'b1;

            @(posedge clk);
            rd_en <= 1'b0;

            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);


            @(posedge clk);
            addr <= 13'h0ABC;
            data_in <= 16'h1234;
            wr_en <= 1'b1;


            @(posedge clk);
            data_in <= 16'h5678;

            @(posedge clk);
            wr_en <= 1'b0;
            rd_en <= 1'b1;

            @(posedge clk);
            rd_en <= 1'b0;

            #2;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Low Check", test_num);


            @(posedge clk);
            addr <= 13'h0010;
            data_in <= 16'hDEAD;
            wr_en <= 1'b1;


            @(posedge clk);
            wr_en <= 1'b0;
            data_in <= 16'hBEEF;

            @(posedge clk);
            rd_en <= 1'b1;

            @(posedge clk);
            rd_en <= 1'b0;

            #2;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Low Check", test_num);


            @(posedge clk);
            addr <= 13'h0001; data_in <= 16'h1111; wr_en <= 1'b1;
            @(posedge clk);
            addr <= 13'h0002; data_in <= 16'h2222; wr_en <= 1'b1;


            @(posedge clk);
            wr_en <= 1'b0;
            addr <= 13'h0001; rd_en <= 1'b1;
            @(posedge clk);


            addr <= 13'h0002; rd_en <= 1'b0;
            @(posedge clk);

            #2;

            #1;


            check_outputs(16'h1111);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
