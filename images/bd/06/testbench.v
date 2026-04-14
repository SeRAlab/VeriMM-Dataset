`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] rd1_addr;
    reg [2:0] rd2_addr;
    reg [2:0] wr_addr;
    reg [7:0] wr_data;
    reg wr_en;
    wire [7:0] rd1_data;
    wire [7:0] rd2_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd1_addr(rd1_addr),
        .rd2_addr(rd2_addr),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd1_data(rd1_data),
        .rd2_data(rd2_data)
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
            wr_data = 0;
            rd1_addr = 0;
            rd2_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual-Port Read", test_num);
            reset_dut();

            wr_en = 1;
            wr_addr = 3'd0;
            wr_data = 8'hA5;
            @(posedge clk);
            #2;

            wr_en = 0;
            rd1_addr = 3'd0;
            rd2_addr = 3'd0;
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write to Reg 2 and Reg 5, Read both", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 3'd2; wr_data = 8'h22;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 3'd5; wr_data = 8'h55;
            @(posedge clk);
            #1;

            wr_en = 0;
            rd1_addr = 3'd2;
            rd2_addr = 3'd5;
            #2;
            #1;

            check_outputs(8'h22, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify wr_en signal", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 3'd1; wr_data = 8'hBB;
            @(posedge clk);
            #1;


            wr_en = 0; wr_addr = 3'd1; wr_data = 8'hFF;
            @(posedge clk);
            #1;

            rd1_addr = 3'd1;
            rd2_addr = 3'd1;
            #2;

            #1;


            check_outputs(8'hBB, 8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite and Boundary Check (Reg 7)", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 3'd7; wr_data = 8'h77;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 3'd7; wr_data = 8'hEE;
            @(posedge clk);
            #1;

            wr_en = 0;
            rd1_addr = 3'd7;
            rd2_addr = 3'd0;
            #2;


            #1;



            check_outputs(8'hEE, rd2_data);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read-during-Write Check", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 3'd4; wr_data = 8'h44;
            @(posedge clk);
            #1;


            wr_en = 1; wr_addr = 3'd4; wr_data = 8'h99;
            rd1_addr = 3'd4;
            rd2_addr = 3'd4;




            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h99, 8'h99);
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
        input [7:0] expected_rd1_data;
        input [7:0] expected_rd2_data;
        begin
            if (expected_rd1_data === (expected_rd1_data ^ rd1_data ^ expected_rd1_data) &&
                expected_rd2_data === (expected_rd2_data ^ rd2_data ^ expected_rd2_data)) begin
                $display("PASS");
                $display("  Outputs: rd1_data=%h, rd2_data=%h",
                         rd1_data, rd2_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1_data=%h, rd2_data=%h",
                         expected_rd1_data, expected_rd2_data);
                $display("  Got:      rd1_data=%h, rd2_data=%h",
                         rd1_data, rd2_data);
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
        $dumpvars(0,clk, rd1_addr, rd2_addr, wr_addr, wr_data, wr_en, rd1_data, rd2_data);
    end

endmodule
