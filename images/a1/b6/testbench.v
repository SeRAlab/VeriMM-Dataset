`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr1;
    reg [2:0] addr2;
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg wr_en;
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
        .rd_en(rd_en),
        .wr_en(wr_en),
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
            rd_en = 0;
            wr_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write and Read...");
            reset_dut();


            wr_en = 1;
            addr1 = 3'd1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_en = 1;
            addr1 = 3'd1;
            addr2 = 3'd0;
            @(posedge clk);

            #1;


            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Dual Port Read...");
            reset_dut();


            wr_en = 1;
            addr1 = 3'd2;
            data_in = 8'h11;
            @(posedge clk);
            #1;


            wr_en = 1;
            addr1 = 3'd5;
            data_in = 8'h22;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_en = 1;
            addr1 = 3'd2;
            addr2 = 3'd5;
            @(posedge clk);

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Write Enable Verification...");
            reset_dut();

            wr_en = 0;
            addr1 = 3'd3;
            data_in = 8'hFF;
            @(posedge clk);
            #1;

            rd_en = 1;
            addr1 = 3'd3;
            addr2 = 3'd3;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Simultaneous Write and Read...");
            reset_dut();


            wr_en = 1; addr1 = 3'd2; data_in = 8'h11;
            @(posedge clk); #1;


            wr_en = 1;
            rd_en = 1;
            addr1 = 3'd7;
            addr2 = 3'd2;
            data_in = 8'h77;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            addr1 = 3'd7;
            addr2 = 3'd7;
            @(posedge clk);

            #1;


            check_outputs(8'h77, 8'h77);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overwrite check...");
            reset_dut();

            wr_en = 1; addr1 = 3'd4; data_in = 8'hAA;
            @(posedge clk); #1;

            wr_en = 1; addr1 = 3'd4; data_in = 8'hBB;
            @(posedge clk); #1;
            wr_en = 0;

            rd_en = 1; addr1 = 3'd4; addr2 = 3'd4;
            @(posedge clk);

            #1;


            check_outputs(8'hBB, 8'hBB);
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
        $dumpvars(0,addr1, addr2, clk, data_in, rd_en, wr_en, data_out1, data_out2);
    end

endmodule
