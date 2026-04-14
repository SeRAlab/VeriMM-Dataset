`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cpu_stall;
    reg [31:0] dmem_in;
    reg [31:0] ex_alu_r;
    reg [1:0] ex_c_drw;
    reg ex_c_rfw;
    reg [1:0] ex_c_wbsource;
    reg [31:0] ex_jalra;
    reg [4:0] ex_rf_waddr;
    reg [31:0] ex_rfb;
    reg [4:0] ex_rt;
    reg rst;
    reg [31:0] wb_wdata;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data;
    wire [1:0] dmem_drw;
    wire [31:0] p_alu_r;
    wire p_c_rfw;
    wire [1:0] p_c_wbsource;
    wire [31:0] p_dout;
    wire [31:0] p_jalra;
    wire [4:0] p_rf_waddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cpu_stall(cpu_stall),
        .dmem_in(dmem_in),
        .ex_alu_r(ex_alu_r),
        .ex_c_drw(ex_c_drw),
        .ex_c_rfw(ex_c_rfw),
        .ex_c_wbsource(ex_c_wbsource),
        .ex_jalra(ex_jalra),
        .ex_rf_waddr(ex_rf_waddr),
        .ex_rfb(ex_rfb),
        .ex_rt(ex_rt),
        .rst(rst),
        .wb_wdata(wb_wdata),
        .dmem_addr(dmem_addr),
        .dmem_data(dmem_data),
        .dmem_drw(dmem_drw),
        .p_alu_r(p_alu_r),
        .p_c_rfw(p_c_rfw),
        .p_c_wbsource(p_c_wbsource),
        .p_dout(p_dout),
        .p_jalra(p_jalra),
        .p_rf_waddr(p_rf_waddr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cpu_stall = 0;
            dmem_in = 0;
            ex_alu_r = 0;
            ex_c_drw = 0;
            ex_c_rfw = 0;
            ex_c_wbsource = 0;
            ex_jalra = 0;
            ex_rf_waddr = 0;
            ex_rfb = 0;
            ex_rt = 0;
            wb_wdata = 0;
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
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(
                32'h0,
                32'h0,
                2'b0,
                32'h0,
                1'b0,
                2'b0,
                32'h0,
                32'h0,
                5'h0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal Operation", test_num);
            reset_dut();


            ex_alu_r = 32'hDEADBEEF;
            ex_rfb = 32'h12345678;
            ex_c_drw = 2'b11;
            ex_c_rfw = 1'b1;
            ex_c_wbsource = 2'b10;
            ex_rf_waddr = 5'h1F;
            ex_jalra = 32'hAAAA5555;
            dmem_in = 32'h87654321;


            @(posedge clk);
            #2;

            #1;


            check_outputs(
                32'hDEADBEEF,
                32'h12345678,
                2'b11,
                32'hDEADBEEF,
                1'b1,
                2'b10,
                32'h87654321,
                32'hAAAA5555,
                5'h1F
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: CPU Stall (Registers should hold value)", test_num);
            reset_dut();


            ex_alu_r = 32'h11112222;
            ex_rfb = 32'h33334444;
            ex_c_drw = 2'b01;
            ex_c_rfw = 1'b1;
            ex_c_wbsource = 2'b01;
            ex_rf_waddr = 5'h0A;
            ex_jalra = 32'h55556666;
            dmem_in = 32'h77778888;
            @(posedge clk);
            #1;


            cpu_stall = 1;
            ex_alu_r = 32'hFFFFFFFF;
            ex_rfb = 32'hEEEEEEEE;
            ex_c_drw = 2'b11;
            ex_c_rfw = 1'b0;
            ex_c_wbsource = 2'b00;
            ex_rf_waddr = 5'h00;
            ex_jalra = 32'h00000000;
            dmem_in = 32'h00000000;

            @(posedge clk);
            #2;



            #1;




            check_outputs(
                32'hFFFFFFFF,
                32'hEEEEEEEE,
                2'b11,
                32'h11112222,
                1'b1,
                2'b01,
                32'h77778888,
                32'h55556666,
                5'h0A
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Data Routing and Addressing", test_num);
            reset_dut();


            ex_alu_r = 32'h1234_ABCD;
            ex_rfb = 32'hBCDE_F012;
            ex_c_drw = 2'b10;
            ex_c_rfw = 1'b1;
            ex_c_wbsource = 2'b00;
            ex_rf_waddr = 5'h10;
            ex_jalra = 32'h0;
            dmem_in = 32'hCAFE_BABE;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                32'h1234_ABCD,
                32'hBCDE_F012,
                2'b10,
                32'h1234_ABCD,
                1'b1,
                2'b00,
                32'hCAFE_BABE,
                32'h0,
                5'h10
            );
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
        input [31:0] expected_dmem_addr;
        input [31:0] expected_dmem_data;
        input [1:0] expected_dmem_drw;
        input [31:0] expected_p_alu_r;
        input expected_p_c_rfw;
        input [1:0] expected_p_c_wbsource;
        input [31:0] expected_p_dout;
        input [31:0] expected_p_jalra;
        input [4:0] expected_p_rf_waddr;
        begin
            if (expected_dmem_addr === (expected_dmem_addr ^ dmem_addr ^ expected_dmem_addr) &&
                expected_dmem_data === (expected_dmem_data ^ dmem_data ^ expected_dmem_data) &&
                expected_dmem_drw === (expected_dmem_drw ^ dmem_drw ^ expected_dmem_drw) &&
                expected_p_alu_r === (expected_p_alu_r ^ p_alu_r ^ expected_p_alu_r) &&
                expected_p_c_rfw === (expected_p_c_rfw ^ p_c_rfw ^ expected_p_c_rfw) &&
                expected_p_c_wbsource === (expected_p_c_wbsource ^ p_c_wbsource ^ expected_p_c_wbsource) &&
                expected_p_dout === (expected_p_dout ^ p_dout ^ expected_p_dout) &&
                expected_p_jalra === (expected_p_jalra ^ p_jalra ^ expected_p_jalra) &&
                expected_p_rf_waddr === (expected_p_rf_waddr ^ p_rf_waddr ^ expected_p_rf_waddr)) begin
                $display("PASS");
                $display("  Outputs: dmem_addr=%h, dmem_data=%h, dmem_drw=%h, p_alu_r=%h, p_c_rfw=%b, p_c_wbsource=%h, p_dout=%h, p_jalra=%h, p_rf_waddr=%h",
                         dmem_addr, dmem_data, dmem_drw, p_alu_r, p_c_rfw, p_c_wbsource, p_dout, p_jalra, p_rf_waddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dmem_addr=%h, dmem_data=%h, dmem_drw=%h, p_alu_r=%h, p_c_rfw=%b, p_c_wbsource=%h, p_dout=%h, p_jalra=%h, p_rf_waddr=%h",
                         expected_dmem_addr, expected_dmem_data, expected_dmem_drw, expected_p_alu_r, expected_p_c_rfw, expected_p_c_wbsource, expected_p_dout, expected_p_jalra, expected_p_rf_waddr);
                $display("  Got:      dmem_addr=%h, dmem_data=%h, dmem_drw=%h, p_alu_r=%h, p_c_rfw=%b, p_c_wbsource=%h, p_dout=%h, p_jalra=%h, p_rf_waddr=%h",
                         dmem_addr, dmem_data, dmem_drw, p_alu_r, p_c_rfw, p_c_wbsource, p_dout, p_jalra, p_rf_waddr);
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
        $dumpvars(0,clk, cpu_stall, dmem_in, ex_alu_r, ex_c_drw, ex_c_rfw, ex_c_wbsource, ex_jalra, ex_rf_waddr, ex_rfb, ex_rt, rst, wb_wdata, dmem_addr, dmem_data, dmem_drw, p_alu_r, p_c_rfw, p_c_wbsource, p_dout, p_jalra, p_rf_waddr);
    end

endmodule
