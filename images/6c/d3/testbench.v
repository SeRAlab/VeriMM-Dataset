`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aluresult;
    reg clk;
    reg [4:0] dest_reg;
    reg memtoreg;
    reg [31:0] read_memdata;
    reg regwrite;
    reg rst;
    reg valid_read_memdata;
    wire [31:0] wb_aluresult;
    wire [4:0] wb_dest_reg;
    wire wb_memtoreg;
    wire [31:0] wb_read_memdata;
    wire wb_regwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluresult(aluresult),
        .clk(clk),
        .dest_reg(dest_reg),
        .memtoreg(memtoreg),
        .read_memdata(read_memdata),
        .regwrite(regwrite),
        .rst(rst),
        .valid_read_memdata(valid_read_memdata),
        .wb_aluresult(wb_aluresult),
        .wb_dest_reg(wb_dest_reg),
        .wb_memtoreg(wb_memtoreg),
        .wb_read_memdata(wb_read_memdata),
        .wb_regwrite(wb_regwrite)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            regwrite = 0;
            memtoreg = 0;
            aluresult = 32'h0;
            read_memdata = 32'h0;
            valid_read_memdata = 0;
            dest_reg = 5'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Post-Reset Verification");
            reset_dut();

            #1 #1;
 check_outputs(32'h0, 5'h0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Standard ALU Instruction Writeback");
            reset_dut();
            regwrite = 1'b1;
            memtoreg = 1'b0;
            aluresult = 32'hABCDE001;
            read_memdata = 32'h0;
            dest_reg = 5'd10;
            valid_read_memdata = 1'b0;

            @(posedge clk);
            #1 #1;
 check_outputs(32'hABCDE001, 5'd10, 1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Memory Load Instruction Writeback");
            reset_dut();
            regwrite = 1'b1;
            memtoreg = 1'b1;
            aluresult = 32'h40;
            read_memdata = 32'h55AAFF00;
            dest_reg = 5'd31;
            valid_read_memdata = 1'b1;

            @(posedge clk);
            #1 #1;
 check_outputs(32'h40, 5'd31, 1'b1, 32'h55AAFF00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: RegWrite Disabled Instruction");
            reset_dut();
            regwrite = 1'b0;
            memtoreg = 1'b0;
            aluresult = 32'h7FFFFFFF;
            read_memdata = 32'h0;
            dest_reg = 5'd5;
            valid_read_memdata = 1'b0;

            @(posedge clk);
            #1 #1;
 check_outputs(32'h7FFFFFFF, 5'd5, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Destination Register R0");
            reset_dut();
            regwrite = 1'b1;
            memtoreg = 1'b0;
            aluresult = 32'h12345678;
            read_memdata = 32'h0;
            dest_reg = 5'd0;
            valid_read_memdata = 1'b0;

            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678, 5'd0, 1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Consecutive Cycle Updates");
            reset_dut();


            regwrite = 1'b1;
            memtoreg = 1'b0;
            aluresult = 32'h11111111;
            dest_reg = 5'd1;
            @(posedge clk);
            #1;


            regwrite = 1'b1;
            memtoreg = 1'b1;
            read_memdata = 32'h22222222;
            dest_reg = 5'd2;
            @(posedge clk);


            #1 #1;
 check_outputs(aluresult, 5'd2, 1'b1, 32'h22222222, 1'b1);
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
        input [31:0] expected_wb_aluresult;
        input [4:0] expected_wb_dest_reg;
        input expected_wb_memtoreg;
        input [31:0] expected_wb_read_memdata;
        input expected_wb_regwrite;
        begin
            if (expected_wb_aluresult === (expected_wb_aluresult ^ wb_aluresult ^ expected_wb_aluresult) &&
                expected_wb_dest_reg === (expected_wb_dest_reg ^ wb_dest_reg ^ expected_wb_dest_reg) &&
                expected_wb_memtoreg === (expected_wb_memtoreg ^ wb_memtoreg ^ expected_wb_memtoreg) &&
                expected_wb_read_memdata === (expected_wb_read_memdata ^ wb_read_memdata ^ expected_wb_read_memdata) &&
                expected_wb_regwrite === (expected_wb_regwrite ^ wb_regwrite ^ expected_wb_regwrite)) begin
                $display("PASS");
                $display("  Outputs: wb_aluresult=%h, wb_dest_reg=%h, wb_memtoreg=%b, wb_read_memdata=%h, wb_regwrite=%b",
                         wb_aluresult, wb_dest_reg, wb_memtoreg, wb_read_memdata, wb_regwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_aluresult=%h, wb_dest_reg=%h, wb_memtoreg=%b, wb_read_memdata=%h, wb_regwrite=%b",
                         expected_wb_aluresult, expected_wb_dest_reg, expected_wb_memtoreg, expected_wb_read_memdata, expected_wb_regwrite);
                $display("  Got:      wb_aluresult=%h, wb_dest_reg=%h, wb_memtoreg=%b, wb_read_memdata=%h, wb_regwrite=%b",
                         wb_aluresult, wb_dest_reg, wb_memtoreg, wb_read_memdata, wb_regwrite);
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
        $dumpvars(0,aluresult, clk, dest_reg, memtoreg, read_memdata, regwrite, rst, valid_read_memdata, wb_aluresult, wb_dest_reg, wb_memtoreg, wb_read_memdata, wb_regwrite);
    end

endmodule
