`timescale 1ns/1ps

module memops_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] i_addr;
    reg i_clk;
    reg [31:0] i_data;
    reg i_lock;
    reg i_op;
    reg [4:0] i_oreg;
    reg i_rst;
    reg i_stb;
    reg i_wb_ack;
    reg [31:0] i_wb_data;
    reg i_wb_err;
    reg i_wb_stall;
    wire o_busy;
    wire o_err;
    wire [31:0] o_result;
    wire o_valid;
    wire [23:0] o_wb_addr;
    wire o_wb_cyc_gbl;
    wire o_wb_cyc_lcl;
    wire [31:0] o_wb_data;
    wire o_wb_stb_gbl;
    wire o_wb_stb_lcl;
    wire o_wb_we;
    wire [4:0] o_wreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memops dut (
        .i_addr(i_addr),
        .i_clk(i_clk),
        .i_data(i_data),
        .i_lock(i_lock),
        .i_op(i_op),
        .i_oreg(i_oreg),
        .i_rst(i_rst),
        .i_stb(i_stb),
        .i_wb_ack(i_wb_ack),
        .i_wb_data(i_wb_data),
        .i_wb_err(i_wb_err),
        .i_wb_stall(i_wb_stall),
        .o_busy(o_busy),
        .o_err(o_err),
        .o_result(o_result),
        .o_valid(o_valid),
        .o_wb_addr(o_wb_addr),
        .o_wb_cyc_gbl(o_wb_cyc_gbl),
        .o_wb_cyc_lcl(o_wb_cyc_lcl),
        .o_wb_data(o_wb_data),
        .o_wb_stb_gbl(o_wb_stb_gbl),
        .o_wb_stb_lcl(o_wb_stb_lcl),
        .o_wb_we(o_wb_we),
        .o_wreg(o_wreg)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_rst = 1;
        i_stb = 0;
        i_lock = 0;
        i_op = 0;
        i_addr = 0;
        i_data = 0;
        i_oreg = 0;
        i_wb_ack = 0;
        i_wb_stall = 0;
        i_wb_err = 0;
        i_wb_data = 0;
        repeat(2) @(posedge i_clk);
        i_rst = 0;
        @(posedge i_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Local Write Operation", test_num);
        reset_dut();


        i_stb = 1;
        i_op = 1;
        i_addr = 32'h0000_1234;
        i_data = 32'hDEAD_BEEF;
        @(posedge i_clk);
        i_stb = 0;


        wait(o_busy);
        i_wb_ack = 1;
        @(posedge i_clk);
        i_wb_ack = 0;



        #1;




        check_outputs(0, 0, 0, 0, 24'h001234, 0, 0, 32'hDEAD_BEEF, 0, 0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Global Read Operation", test_num);
        reset_dut();


        i_stb = 1;
        i_op = 0;
        i_addr = 32'h8000_5678;
        i_oreg = 5'h0A;
        @(posedge i_clk);
        i_stb = 0;


        wait(o_busy);
        i_wb_data = 32'hCAFE_BABE;
        i_wb_ack = 1;
        @(posedge i_clk);
        i_wb_ack = 0;


        #1;



        check_outputs(0, 0, 32'hCAFE_BABE, 1, 24'h005678, 0, 0, 0, 0, 0, 0, 5'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Local Read with Memory Error", test_num);
        reset_dut();


        i_stb = 1;
        i_op = 0;
        i_addr = 32'h0000_4444;
        @(posedge i_clk);
        i_stb = 0;


        wait(o_busy);
        i_wb_err = 1;
        @(posedge i_clk);
        i_wb_err = 0;


        #1;



        check_outputs(0, 1, 0, 0, 24'h004444, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Global Write with Bus Stall", test_num);
        reset_dut();


        i_stb = 1;
        i_op = 1;
        i_addr = 32'h8000_9999;
        i_data = 32'h1122_3344;
        @(posedge i_clk);
        i_stb = 0;


        i_wb_stall = 1;
        repeat(2) @(posedge i_clk);
        i_wb_stall = 0;


        i_wb_ack = 1;
        @(posedge i_clk);
        i_wb_ack = 0;


        #1;



        check_outputs(0, 0, 0, 0, 24'h009999, 0, 0, 32'h1122_3344, 0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Local Read with Lock bit set", test_num);
        reset_dut();


        i_stb = 1;
        i_lock = 1;
        i_op = 0;
        i_addr = 32'h0000_AAAA;
        i_oreg = 5'h1F;
        @(posedge i_clk);
        i_stb = 0;


        wait(o_busy);
        i_wb_data = 32'h5555_AAAA;
        i_wb_ack = 1;
        @(posedge i_clk);
        i_wb_ack = 0;
        i_lock = 0;


        #1;



        check_outputs(0, 0, 32'h5555_AAAA, 1, 24'h00AAAA, 0, 0, 0, 0, 0, 0, 5'h1F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memops Testbench");
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
        input expected_o_busy;
        input expected_o_err;
        input [31:0] expected_o_result;
        input expected_o_valid;
        input [23:0] expected_o_wb_addr;
        input expected_o_wb_cyc_gbl;
        input expected_o_wb_cyc_lcl;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_stb_gbl;
        input expected_o_wb_stb_lcl;
        input expected_o_wb_we;
        input [4:0] expected_o_wreg;
        begin
            if (expected_o_busy === (expected_o_busy ^ o_busy ^ expected_o_busy) &&
                expected_o_err === (expected_o_err ^ o_err ^ expected_o_err) &&
                expected_o_result === (expected_o_result ^ o_result ^ expected_o_result) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid) &&
                expected_o_wb_addr === (expected_o_wb_addr ^ o_wb_addr ^ expected_o_wb_addr) &&
                expected_o_wb_cyc_gbl === (expected_o_wb_cyc_gbl ^ o_wb_cyc_gbl ^ expected_o_wb_cyc_gbl) &&
                expected_o_wb_cyc_lcl === (expected_o_wb_cyc_lcl ^ o_wb_cyc_lcl ^ expected_o_wb_cyc_lcl) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_stb_gbl === (expected_o_wb_stb_gbl ^ o_wb_stb_gbl ^ expected_o_wb_stb_gbl) &&
                expected_o_wb_stb_lcl === (expected_o_wb_stb_lcl ^ o_wb_stb_lcl ^ expected_o_wb_stb_lcl) &&
                expected_o_wb_we === (expected_o_wb_we ^ o_wb_we ^ expected_o_wb_we) &&
                expected_o_wreg === (expected_o_wreg ^ o_wreg ^ expected_o_wreg)) begin
                $display("PASS");
                $display("  Outputs: o_busy=%b, o_err=%b, o_result=%h, o_valid=%b, o_wb_addr=%h, o_wb_cyc_gbl=%b, o_wb_cyc_lcl=%b, o_wb_data=%h, o_wb_stb_gbl=%b, o_wb_stb_lcl=%b, o_wb_we=%b, o_wreg=%h",
                         o_busy, o_err, o_result, o_valid, o_wb_addr, o_wb_cyc_gbl, o_wb_cyc_lcl, o_wb_data, o_wb_stb_gbl, o_wb_stb_lcl, o_wb_we, o_wreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_busy=%b, o_err=%b, o_result=%h, o_valid=%b, o_wb_addr=%h, o_wb_cyc_gbl=%b, o_wb_cyc_lcl=%b, o_wb_data=%h, o_wb_stb_gbl=%b, o_wb_stb_lcl=%b, o_wb_we=%b, o_wreg=%h",
                         expected_o_busy, expected_o_err, expected_o_result, expected_o_valid, expected_o_wb_addr, expected_o_wb_cyc_gbl, expected_o_wb_cyc_lcl, expected_o_wb_data, expected_o_wb_stb_gbl, expected_o_wb_stb_lcl, expected_o_wb_we, expected_o_wreg);
                $display("  Got:      o_busy=%b, o_err=%b, o_result=%h, o_valid=%b, o_wb_addr=%h, o_wb_cyc_gbl=%b, o_wb_cyc_lcl=%b, o_wb_data=%h, o_wb_stb_gbl=%b, o_wb_stb_lcl=%b, o_wb_we=%b, o_wreg=%h",
                         o_busy, o_err, o_result, o_valid, o_wb_addr, o_wb_cyc_gbl, o_wb_cyc_lcl, o_wb_data, o_wb_stb_gbl, o_wb_stb_lcl, o_wb_we, o_wreg);
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
        $dumpvars(0,i_addr, i_clk, i_data, i_lock, i_op, i_oreg, i_rst, i_stb, i_wb_ack, i_wb_data, i_wb_err, i_wb_stall, o_busy, o_err, o_result, o_valid, o_wb_addr, o_wb_cyc_gbl, o_wb_cyc_lcl, o_wb_data, o_wb_stb_gbl, o_wb_stb_lcl, o_wb_we, o_wreg);
    end

endmodule
