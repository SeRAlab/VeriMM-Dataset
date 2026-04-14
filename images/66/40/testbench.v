`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [2:0] rd;
    reg [2:0] rs1;
    reg [2:0] rs2;
    reg rst;
    reg write_reg;
    wire [15:0] reg1data;
    wire [15:0] reg2data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .rst(rst),
        .write_reg(write_reg),
        .reg1data(reg1data),
        .reg2data(reg2data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_reg = 0;
            data_in = 0;
            rd = 0;
            rs1 = 0;
            rs2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();


            rs1 = 3'd2;
            rs2 = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Register Write/Read", test_num);
            reset_dut();


            rd = 3'd1;
            data_in = 16'hABCD;
            write_reg = 1;
            @(posedge clk);
            #1;


            write_reg = 0;
            rs1 = 3'd1;
            rs2 = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            rd = 3'd4;
            data_in = 16'hFFFF;
            write_reg = 0;
            @(posedge clk);
            #1;


            rs1 = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dual Register Read", test_num);
            reset_dut();


            rd = 3'd2;
            data_in = 16'h1234;
            write_reg = 1;
            @(posedge clk);
            #1;


            rd = 3'd7;
            data_in = 16'h5678;
            write_reg = 1;
            @(posedge clk);
            #1;


            write_reg = 0;
            rs1 = 3'd2;
            rs2 = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Register Overwrite", test_num);
            reset_dut();


            rd = 3'd5;
            data_in = 16'hAAAA;
            write_reg = 1;
            @(posedge clk);
            #1;


            data_in = 16'h5555;
            @(posedge clk);
            #1;

            write_reg = 0;
            rs1 = 3'd5;
            rs2 = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Full Register File Test", test_num);
            reset_dut();


            for(i=0; i<8; i=i+1) begin
                rd = i;
                data_in = 16'hF000 + i;
                write_reg = 1;
                @(posedge clk);
                #1;
            end

            write_reg = 0;

            rs1 = 3'd0;
            rs2 = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF000, 16'hF006);
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
        input [15:0] expected_reg1data;
        input [15:0] expected_reg2data;
        begin
            if (expected_reg1data === (expected_reg1data ^ reg1data ^ expected_reg1data) &&
                expected_reg2data === (expected_reg2data ^ reg2data ^ expected_reg2data)) begin
                $display("PASS");
                $display("  Outputs: reg1data=%h, reg2data=%h",
                         reg1data, reg2data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg1data=%h, reg2data=%h",
                         expected_reg1data, expected_reg2data);
                $display("  Got:      reg1data=%h, reg2data=%h",
                         reg1data, reg2data);
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
        $dumpvars(0,clk, data_in, rd, rs1, rs2, rst, write_reg, reg1data, reg2data);
    end

endmodule
