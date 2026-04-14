`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rd_addr;
    reg [3:0] wr_addr;
    reg wr_en;
    reg [7:0] wr_value;
    wire [7:0] rd_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .wr_value(wr_value),
        .rd_value(rd_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            wr_addr = 0;
            wr_value = 0;
            rd_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 4'h5;
            wr_value = 8'hA5;
            @(posedge clk); #1;


            wr_en = 0;
            rd_addr = 4'h5;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Boundary Address (0x0)", test_num);
            reset_dut();

            wr_en = 1;
            wr_addr = 4'h0;
            wr_value = 8'h01;
            @(posedge clk); #1;

            wr_en = 0;
            rd_addr = 4'h0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Boundary Address (0xF)", test_num);
            reset_dut();

            wr_en = 1;
            wr_addr = 4'hF;
            wr_value = 8'hFF;
            @(posedge clk); #1;

            wr_en = 0;
            rd_addr = 4'hF;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Write Enable Verification", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 4'h7;
            wr_value = 8'h77;
            @(posedge clk); #1;


            wr_en = 0;
            wr_addr = 4'h7;
            wr_value = 8'h88;
            @(posedge clk); #1;

            rd_addr = 4'h7;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Memory Overwrite", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 4'hA;
            wr_value = 8'h11;
            @(posedge clk); #1;


            wr_addr = 4'hA;
            wr_value = 8'h22;
            @(posedge clk); #1;

            wr_en = 0;
            rd_addr = 4'hA;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Simultaneous Read/Write", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 4'h3;
            wr_value = 8'h33;
            @(posedge clk); #1;


            wr_en = 1;
            wr_addr = 4'h4;
            wr_value = 8'h44;
            rd_addr = 4'h3;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h33);
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
        input [7:0] expected_rd_value;
        begin
            if (expected_rd_value === (expected_rd_value ^ rd_value ^ expected_rd_value)) begin
                $display("PASS");
                $display("  Outputs: rd_value=%h",
                         rd_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_value=%h",
                         expected_rd_value);
                $display("  Got:      rd_value=%h",
                         rd_value);
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
        $dumpvars(0,clk, rd_addr, wr_addr, wr_en, wr_value, rd_value);
    end

endmodule
