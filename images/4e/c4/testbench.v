`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] EX_alu_out;
    reg [31:0] EX_alu_out_t;
    reg EX_flush;
    reg [8:0] EX_load_op;
    reg [31:0] EX_memaddr;
    reg EX_memread;
    reg EX_memtoreg;
    reg EX_memwrite;
    reg EX_regwrite;
    reg [4:0] EX_rt_rd;
    reg EX_stall;
    reg [5:0] EX_store_op;
    reg M_stall;
    reg clk;
    reg rst;
    wire [31:0] M_alu_out;
    wire [8:0] M_load_op;
    wire [31:0] M_memaddr;
    wire M_memread;
    wire M_memtoreg;
    wire M_memwrite;
    wire M_regwrite;
    wire [4:0] M_rt_rd;
    wire [5:0] M_store_op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_alu_out(EX_alu_out),
        .EX_alu_out_t(EX_alu_out_t),
        .EX_flush(EX_flush),
        .EX_load_op(EX_load_op),
        .EX_memaddr(EX_memaddr),
        .EX_memread(EX_memread),
        .EX_memtoreg(EX_memtoreg),
        .EX_memwrite(EX_memwrite),
        .EX_regwrite(EX_regwrite),
        .EX_rt_rd(EX_rt_rd),
        .EX_stall(EX_stall),
        .EX_store_op(EX_store_op),
        .M_stall(M_stall),
        .clk(clk),
        .rst(rst),
        .M_alu_out(M_alu_out),
        .M_load_op(M_load_op),
        .M_memaddr(M_memaddr),
        .M_memread(M_memread),
        .M_memtoreg(M_memtoreg),
        .M_memwrite(M_memwrite),
        .M_regwrite(M_regwrite),
        .M_rt_rd(M_rt_rd),
        .M_store_op(M_store_op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            EX_stall = 0;
            EX_flush = 0;
            M_stall = 0;
            EX_regwrite = 0;
            EX_memtoreg = 0;
            EX_memread = 0;
            EX_memwrite = 0;
            EX_memaddr = 0;
            EX_load_op = 0;
            EX_store_op = 0;
            EX_alu_out = 0;
            EX_alu_out_t = 0;
            EX_rt_rd = 0;
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
            $display("Testcase %03d: Basic Pass-through", test_num);
            reset_dut();

            EX_regwrite = 1;
            EX_memtoreg = 0;
            EX_memread = 1;
            EX_memwrite = 0;
            EX_memaddr = 32'hAABBCCDD;
            EX_load_op = 9'h155;
            EX_store_op = 6'h2A;
            EX_alu_out = 32'h12345678;
            EX_rt_rd = 5'h1F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 9'h155, 32'hAABBCCDD, 1'b1, 1'b0, 1'b0, 1'b1, 5'h1F, 6'h2A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Pipeline Flush", test_num);
            reset_dut();


            EX_regwrite = 1;
            EX_alu_out = 32'hFFFFFFFF;
            EX_flush = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 9'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 6'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Memory Stall", test_num);
            reset_dut();


            EX_regwrite = 1;
            EX_alu_out = 32'hD00DBEEF;
            @(posedge clk);
            #2;


            M_stall = 1;
            EX_regwrite = 0;
            EX_alu_out = 32'hCAFEBABE;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hD00DBEEF, 9'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b1, 5'h0, 6'h0);


            M_stall = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCAFEBABE, 9'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 6'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();

            EX_regwrite = 1;
            EX_alu_out = 32'h11223344;
            rst = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 9'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 6'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Complex Bit Patterns", test_num);
            reset_dut();

            EX_load_op = 9'b101010101;
            EX_store_op = 6'b010101;
            EX_rt_rd = 5'b11011;
            EX_memaddr = 32'h5555AAAA;
            EX_alu_out = 32'hAAAA5555;
            EX_regwrite = 1;
            EX_memread = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA5555, 9'b101010101, 32'h5555AAAA, 1'b1, 1'b0, 1'b0, 1'b1, 5'b11011, 6'b010101);
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
        input [31:0] expected_M_alu_out;
        input [8:0] expected_M_load_op;
        input [31:0] expected_M_memaddr;
        input expected_M_memread;
        input expected_M_memtoreg;
        input expected_M_memwrite;
        input expected_M_regwrite;
        input [4:0] expected_M_rt_rd;
        input [5:0] expected_M_store_op;
        begin
            if (expected_M_alu_out === (expected_M_alu_out ^ M_alu_out ^ expected_M_alu_out) &&
                expected_M_load_op === (expected_M_load_op ^ M_load_op ^ expected_M_load_op) &&
                expected_M_memaddr === (expected_M_memaddr ^ M_memaddr ^ expected_M_memaddr) &&
                expected_M_memread === (expected_M_memread ^ M_memread ^ expected_M_memread) &&
                expected_M_memtoreg === (expected_M_memtoreg ^ M_memtoreg ^ expected_M_memtoreg) &&
                expected_M_memwrite === (expected_M_memwrite ^ M_memwrite ^ expected_M_memwrite) &&
                expected_M_regwrite === (expected_M_regwrite ^ M_regwrite ^ expected_M_regwrite) &&
                expected_M_rt_rd === (expected_M_rt_rd ^ M_rt_rd ^ expected_M_rt_rd) &&
                expected_M_store_op === (expected_M_store_op ^ M_store_op ^ expected_M_store_op)) begin
                $display("PASS");
                $display("  Outputs: M_alu_out=%h, M_load_op=%h, M_memaddr=%h, M_memread=%b, M_memtoreg=%b, M_memwrite=%b, M_regwrite=%b, M_rt_rd=%h, M_store_op=%h",
                         M_alu_out, M_load_op, M_memaddr, M_memread, M_memtoreg, M_memwrite, M_regwrite, M_rt_rd, M_store_op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_alu_out=%h, M_load_op=%h, M_memaddr=%h, M_memread=%b, M_memtoreg=%b, M_memwrite=%b, M_regwrite=%b, M_rt_rd=%h, M_store_op=%h",
                         expected_M_alu_out, expected_M_load_op, expected_M_memaddr, expected_M_memread, expected_M_memtoreg, expected_M_memwrite, expected_M_regwrite, expected_M_rt_rd, expected_M_store_op);
                $display("  Got:      M_alu_out=%h, M_load_op=%h, M_memaddr=%h, M_memread=%b, M_memtoreg=%b, M_memwrite=%b, M_regwrite=%b, M_rt_rd=%h, M_store_op=%h",
                         M_alu_out, M_load_op, M_memaddr, M_memread, M_memtoreg, M_memwrite, M_regwrite, M_rt_rd, M_store_op);
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
        $dumpvars(0,EX_alu_out, EX_alu_out_t, EX_flush, EX_load_op, EX_memaddr, EX_memread, EX_memtoreg, EX_memwrite, EX_regwrite, EX_rt_rd, EX_stall, EX_store_op, M_stall, clk, rst, M_alu_out, M_load_op, M_memaddr, M_memread, M_memtoreg, M_memwrite, M_regwrite, M_rt_rd, M_store_op);
    end

endmodule
