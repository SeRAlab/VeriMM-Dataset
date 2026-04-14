`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ALUop;
    reg asel;
    reg bsel;
    reg clk;
    reg [15:0] datapath_in;
    reg loada;
    reg loadb;
    reg loadc;
    reg loads;
    reg [2:0] readnum;
    reg [1:0] shift;
    reg vsel;
    reg write;
    reg [2:0] writenum;
    wire [15:0] datapath_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .asel(asel),
        .bsel(bsel),
        .clk(clk),
        .datapath_in(datapath_in),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads),
        .readnum(readnum),
        .shift(shift),
        .vsel(vsel),
        .write(write),
        .writenum(writenum),
        .datapath_out(datapath_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALUop = 2'b00;
            asel = 1'b0;
            bsel = 1'b0;
            datapath_in = 16'h0;
            loada = 1'b0;
            loadb = 1'b0;
            loadc = 1'b0;
            loads = 1'b0;
            readnum = 3'b000;
            shift = 2'b00;
            vsel = 1'b0;
            write = 1'b0;
            writenum = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Addition...");
            reset_dut();


            vsel = 1; datapath_in = 16'd7; writenum = 3'd0; write = 1;
            @(posedge clk); #1; write = 0;


            vsel = 1; datapath_in = 16'd3; writenum = 3'd1; write = 1;
            @(posedge clk); #1; write = 0;


            readnum = 3'd0; loada = 1;
            @(posedge clk); #1; loada = 0;


            readnum = 3'd1; loadb = 1;
            @(posedge clk); #1; loadb = 0;


            asel = 0; bsel = 0; shift = 2'b00; ALUop = 2'b00; loadc = 1;
            @(posedge clk); #1; loadc = 0;

            #1;


            check_outputs(16'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: LSL and Add...");
            reset_dut();


            vsel = 1; datapath_in = 16'd5; writenum = 3'd2; write = 1; @(posedge clk); #1;
            vsel = 1; datapath_in = 16'd2; writenum = 3'd3; write = 1; @(posedge clk); #1;
            write = 0;


            readnum = 3'd2; loada = 1; @(posedge clk); #1; loada = 0;
            readnum = 3'd3; loadb = 1; @(posedge clk); #1; loadb = 0;


            asel = 0; bsel = 0; shift = 2'b01; ALUop = 2'b00; loadc = 1;
            @(posedge clk); #1; loadc = 0;

            #1;


            check_outputs(16'd9, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Subtraction and Status...");
            reset_dut();


            vsel = 1; datapath_in = 16'd20; writenum = 3'd4; write = 1; @(posedge clk); #1;
            vsel = 1; datapath_in = 16'd30; writenum = 3'd5; write = 1; @(posedge clk); #1;
            write = 0;

            readnum = 3'd4; loada = 1; @(posedge clk); #1; loada = 0;
            readnum = 3'd5; loadb = 1; @(posedge clk); #1; loadb = 0;


            asel = 0; bsel = 0; shift = 2'b00; ALUop = 2'b01; loadc = 1; loads = 1;
            @(posedge clk); #1; loadc = 0; loads = 0;



            #1;




            check_outputs(16'hFFF6, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Logical AND...");
            reset_dut();

            vsel = 1; datapath_in = 16'hAAAA; writenum = 3'd6; write = 1; @(posedge clk); #1;
            vsel = 1; datapath_in = 16'hF0F0; writenum = 3'd7; write = 1; @(posedge clk); #1;
            write = 0;

            readnum = 3'd6; loada = 1; @(posedge clk); #1; loada = 0;
            readnum = 3'd7; loadb = 1; @(posedge clk); #1; loadb = 0;


            asel = 0; bsel = 0; shift = 2'b00; ALUop = 2'b10; loadc = 1;
            @(posedge clk); #1; loadc = 0;

            #1;


            check_outputs(16'hA0A0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write Back and Reuse...");
            reset_dut();


            vsel = 1; datapath_in = 16'd10; writenum = 3'd0; write = 1; @(posedge clk); #1;
            vsel = 1; datapath_in = 16'd5;  writenum = 3'd1; write = 1; @(posedge clk); #1;
            write = 0;


            readnum = 3'd0; loada = 1; @(posedge clk); #1; loada = 0;
            readnum = 3'd1; loadb = 1; @(posedge clk); #1; loadb = 0;
            asel = 0; bsel = 0; ALUop = 2'b00; loadc = 1; @(posedge clk); #1; loadc = 0;


            vsel = 0; writenum = 3'd2; write = 1; @(posedge clk); #1; write = 0;


            readnum = 3'd2; loada = 1; @(posedge clk); #1; loada = 0;
            readnum = 3'd1; loadb = 1; @(posedge clk); #1; loadb = 0;
            asel = 0; bsel = 0; ALUop = 2'b00; loadc = 1; @(posedge clk); #1; loadc = 0;

            #1;


            check_outputs(16'd20, 1'b0);
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
        input [15:0] expected_datapath_out;
        input expected_status;
        begin
            if (expected_datapath_out === (expected_datapath_out ^ datapath_out ^ expected_datapath_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: datapath_out=%h, status=%b",
                         datapath_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datapath_out=%h, status=%b",
                         expected_datapath_out, expected_status);
                $display("  Got:      datapath_out=%h, status=%b",
                         datapath_out, status);
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
        $dumpvars(0,ALUop, asel, bsel, clk, datapath_in, loada, loadb, loadc, loads, readnum, shift, vsel, write, writenum, datapath_out, status);
    end

endmodule
