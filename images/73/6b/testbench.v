`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Branch;
    reg [31:0] Branch_addr;
    reg Clk;
    reg [2:0] Condition;
    reg Less;
    reg [31:0] MemData;
    reg MemWBSrc;
    reg [3:0] Mem_Byte_Write;
    reg Overflow;
    reg OverflowEn;
    reg [31:0] PC_add;
    reg [2:0] PC_write;
    reg [4:0] Rd;
    reg [3:0] Rd_Write_Byte_en;
    reg [31:0] WBData;
    reg Zero;
    reg flush;
    reg stall;
    wire [31:0] Branch_addr_out;
    wire Branch_out;
    wire [2:0] Condition_out;
    wire Less_out;
    wire [31:0] MemData_out;
    wire MemWBSrc_out;
    wire [3:0] Mem_Byte_Write_out;
    wire OverflowEn_out;
    wire Overflow_out;
    wire [31:0] PC_add_out;
    wire [2:0] PC_write_out;
    wire [3:0] Rd_Write_Byte_en_out;
    wire [4:0] Rd_out;
    wire [31:0] WBData_out;
    wire Zero_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .Branch_addr(Branch_addr),
        .Clk(Clk),
        .Condition(Condition),
        .Less(Less),
        .MemData(MemData),
        .MemWBSrc(MemWBSrc),
        .Mem_Byte_Write(Mem_Byte_Write),
        .Overflow(Overflow),
        .OverflowEn(OverflowEn),
        .PC_add(PC_add),
        .PC_write(PC_write),
        .Rd(Rd),
        .Rd_Write_Byte_en(Rd_Write_Byte_en),
        .WBData(WBData),
        .Zero(Zero),
        .flush(flush),
        .stall(stall),
        .Branch_addr_out(Branch_addr_out),
        .Branch_out(Branch_out),
        .Condition_out(Condition_out),
        .Less_out(Less_out),
        .MemData_out(MemData_out),
        .MemWBSrc_out(MemWBSrc_out),
        .Mem_Byte_Write_out(Mem_Byte_Write_out),
        .OverflowEn_out(OverflowEn_out),
        .Overflow_out(Overflow_out),
        .PC_add_out(PC_add_out),
        .PC_write_out(PC_write_out),
        .Rd_Write_Byte_en_out(Rd_Write_Byte_en_out),
        .Rd_out(Rd_out),
        .WBData_out(WBData_out),
        .Zero_out(Zero_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Branch = 0;
        Branch_addr = 0;
        Condition = 0;
        Less = 0;
        MemData = 0;
        MemWBSrc = 0;
        Mem_Byte_Write = 0;
        Overflow = 0;
        OverflowEn = 0;
        PC_add = 0;
        PC_write = 0;
        Rd = 0;
        Rd_Write_Byte_en = 0;
        WBData = 0;
        Zero = 0;
        flush = 1;
        stall = 0;
        @(posedge Clk);
        #1;
        flush = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();


        Branch_addr = 32'h12345678;
        PC_add = 32'hABCDE000;
        Condition = 3'b101;
        Branch = 1'b1;
        PC_write = 3'b010;
        Mem_Byte_Write = 4'b1111;
        Rd_Write_Byte_en = 4'b1010;
        MemWBSrc = 1'b1;
        OverflowEn = 1'b1;
        MemData = 32'hDEADBEEF;
        WBData = 32'h87654321;
        Less = 1'b0;
        Zero = 1'b1;
        Overflow = 1'b0;
        Rd = 5'd16;
        stall = 0;
        flush = 0;

        @(posedge Clk);
        #2;

        $display("Testcase %0d: Normal Propagation", test_num);
        #1;

        check_outputs(32'h12345678, 1'b1, 3'b101, 1'b0, 32'hDEADBEEF, 1'b1, 4'b1111, 1'b1, 1'b0, 32'hABCDE000, 3'b010, 4'b1010, 5'd16, 32'h87654321, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();


        Branch_addr = 32'hFFFFFFFF;
        MemData = 32'hFFFFFFFF;

        flush = 1;
        stall = 0;

        @(posedge Clk);
        #2;

        $display("Testcase %0d: Flush Active", test_num);

        #1;


        check_outputs(32'h0, 0, 3'h0, 0, 32'h0, 0, 4'h0, 0, 0, 32'h0, 3'h0, 4'h0, 5'h0, 32'h0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();


        Branch_addr = 32'hAAAA_AAAA;
        WBData = 32'hBBBB_BBBB;
        Rd = 5'd10;
        stall = 0;
        flush = 0;
        @(posedge Clk);
        #1;


        stall = 1;
        Branch_addr = 32'h1111_1111;
        WBData = 32'h2222_2222;
        Rd = 5'd31;

        @(posedge Clk);
        #2;

        $display("Testcase %0d: Stall Active (should hold AAAA...)", test_num);

        #1;


        check_outputs(32'hAAAA_AAAA, 0, 3'h0, 0, 32'h0, 0, 4'h0, 0, 0, 32'h0, 3'h0, 4'h0, 5'd10, 32'hBBBB_BBBB, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();


        Branch_addr = 32'h5555_6666;
        stall = 0;
        flush = 0;
        @(posedge Clk);
        #1;


        flush = 1;
        stall = 1;
        Branch_addr = 32'h9999_8888;

        @(posedge Clk);
        #2;

        $display("Testcase %0d: Flush Priority over Stall", test_num);

        #1;


        check_outputs(32'h0, 0, 3'h0, 0, 32'h0, 0, 4'h0, 0, 0, 32'h0, 3'h0, 4'h0, 5'h0, 32'h0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();


        Branch_addr = 32'hA;
        @(posedge Clk);
        #1;


        Branch_addr = 32'hB;
        @(posedge Clk);
        #2;

        $display("Testcase %0d: Consecutive Data Flow", test_num);
        #1;

        check_outputs(32'hB, 0, 3'h0, 0, 32'h0, 0, 4'h0, 0, 0, 32'h0, 3'h0, 4'h0, 5'h0, 32'h0, 0);
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
        input [31:0] expected_Branch_addr_out;
        input expected_Branch_out;
        input [2:0] expected_Condition_out;
        input expected_Less_out;
        input [31:0] expected_MemData_out;
        input expected_MemWBSrc_out;
        input [3:0] expected_Mem_Byte_Write_out;
        input expected_OverflowEn_out;
        input expected_Overflow_out;
        input [31:0] expected_PC_add_out;
        input [2:0] expected_PC_write_out;
        input [3:0] expected_Rd_Write_Byte_en_out;
        input [4:0] expected_Rd_out;
        input [31:0] expected_WBData_out;
        input expected_Zero_out;
        begin
            if (expected_Branch_addr_out === (expected_Branch_addr_out ^ Branch_addr_out ^ expected_Branch_addr_out) &&
                expected_Branch_out === (expected_Branch_out ^ Branch_out ^ expected_Branch_out) &&
                expected_Condition_out === (expected_Condition_out ^ Condition_out ^ expected_Condition_out) &&
                expected_Less_out === (expected_Less_out ^ Less_out ^ expected_Less_out) &&
                expected_MemData_out === (expected_MemData_out ^ MemData_out ^ expected_MemData_out) &&
                expected_MemWBSrc_out === (expected_MemWBSrc_out ^ MemWBSrc_out ^ expected_MemWBSrc_out) &&
                expected_Mem_Byte_Write_out === (expected_Mem_Byte_Write_out ^ Mem_Byte_Write_out ^ expected_Mem_Byte_Write_out) &&
                expected_OverflowEn_out === (expected_OverflowEn_out ^ OverflowEn_out ^ expected_OverflowEn_out) &&
                expected_Overflow_out === (expected_Overflow_out ^ Overflow_out ^ expected_Overflow_out) &&
                expected_PC_add_out === (expected_PC_add_out ^ PC_add_out ^ expected_PC_add_out) &&
                expected_PC_write_out === (expected_PC_write_out ^ PC_write_out ^ expected_PC_write_out) &&
                expected_Rd_Write_Byte_en_out === (expected_Rd_Write_Byte_en_out ^ Rd_Write_Byte_en_out ^ expected_Rd_Write_Byte_en_out) &&
                expected_Rd_out === (expected_Rd_out ^ Rd_out ^ expected_Rd_out) &&
                expected_WBData_out === (expected_WBData_out ^ WBData_out ^ expected_WBData_out) &&
                expected_Zero_out === (expected_Zero_out ^ Zero_out ^ expected_Zero_out)) begin
                $display("PASS");
                $display("  Outputs: Branch_addr_out=%h, Branch_out=%b, Condition_out=%h, Less_out=%b, MemData_out=%h, MemWBSrc_out=%b, Mem_Byte_Write_out=%h, OverflowEn_out=%b, Overflow_out=%b, PC_add_out=%h, PC_write_out=%h, Rd_Write_Byte_en_out=%h, Rd_out=%h, WBData_out=%h, Zero_out=%b",
                         Branch_addr_out, Branch_out, Condition_out, Less_out, MemData_out, MemWBSrc_out, Mem_Byte_Write_out, OverflowEn_out, Overflow_out, PC_add_out, PC_write_out, Rd_Write_Byte_en_out, Rd_out, WBData_out, Zero_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Branch_addr_out=%h, Branch_out=%b, Condition_out=%h, Less_out=%b, MemData_out=%h, MemWBSrc_out=%b, Mem_Byte_Write_out=%h, OverflowEn_out=%b, Overflow_out=%b, PC_add_out=%h, PC_write_out=%h, Rd_Write_Byte_en_out=%h, Rd_out=%h, WBData_out=%h, Zero_out=%b",
                         expected_Branch_addr_out, expected_Branch_out, expected_Condition_out, expected_Less_out, expected_MemData_out, expected_MemWBSrc_out, expected_Mem_Byte_Write_out, expected_OverflowEn_out, expected_Overflow_out, expected_PC_add_out, expected_PC_write_out, expected_Rd_Write_Byte_en_out, expected_Rd_out, expected_WBData_out, expected_Zero_out);
                $display("  Got:      Branch_addr_out=%h, Branch_out=%b, Condition_out=%h, Less_out=%b, MemData_out=%h, MemWBSrc_out=%b, Mem_Byte_Write_out=%h, OverflowEn_out=%b, Overflow_out=%b, PC_add_out=%h, PC_write_out=%h, Rd_Write_Byte_en_out=%h, Rd_out=%h, WBData_out=%h, Zero_out=%b",
                         Branch_addr_out, Branch_out, Condition_out, Less_out, MemData_out, MemWBSrc_out, Mem_Byte_Write_out, OverflowEn_out, Overflow_out, PC_add_out, PC_write_out, Rd_Write_Byte_en_out, Rd_out, WBData_out, Zero_out);
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
        $dumpvars(0,Branch, Branch_addr, Clk, Condition, Less, MemData, MemWBSrc, Mem_Byte_Write, Overflow, OverflowEn, PC_add, PC_write, Rd, Rd_Write_Byte_en, WBData, Zero, flush, stall, Branch_addr_out, Branch_out, Condition_out, Less_out, MemData_out, MemWBSrc_out, Mem_Byte_Write_out, OverflowEn_out, Overflow_out, PC_add_out, PC_write_out, Rd_Write_Byte_en_out, Rd_out, WBData_out, Zero_out);
    end

endmodule
