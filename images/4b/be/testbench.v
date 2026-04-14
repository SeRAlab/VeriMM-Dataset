`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] MemData_Mem;
    reg MemRead_Mem;
    reg [4:0] Rd_Mem;
    reg [3:0] Rd_write_byte_en_Mem;
    reg RegWrite_Mem;
    reg [31:0] WBData_Mem;
    reg clk;
    reg flush;
    reg stall;
    wire [31:0] MemData_Wr;
    wire MemRead_Wr;
    wire [4:0] Rd_Wr;
    wire [3:0] Rd_write_byte_en_Wr;
    wire RegWrite_Wr;
    wire [31:0] WBData_Wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemData_Mem(MemData_Mem),
        .MemRead_Mem(MemRead_Mem),
        .Rd_Mem(Rd_Mem),
        .Rd_write_byte_en_Mem(Rd_write_byte_en_Mem),
        .RegWrite_Mem(RegWrite_Mem),
        .WBData_Mem(WBData_Mem),
        .clk(clk),
        .flush(flush),
        .stall(stall),
        .MemData_Wr(MemData_Wr),
        .MemRead_Wr(MemRead_Wr),
        .Rd_Wr(Rd_Wr),
        .Rd_write_byte_en_Wr(Rd_write_byte_en_Wr),
        .RegWrite_Wr(RegWrite_Wr),
        .WBData_Wr(WBData_Wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            stall = 0;
            flush = 1;
            MemData_Mem = 0;
            MemRead_Mem = 0;
            Rd_Mem = 0;
            Rd_write_byte_en_Mem = 0;
            RegWrite_Mem = 0;
            WBData_Mem = 0;
            @(negedge clk);
            flush = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Data Transfer", test_num);
            reset_dut();

            stall = 0;
            flush = 0;
            MemData_Mem = 32'hAAAA_BBBB;
            MemRead_Mem = 1;
            Rd_Mem = 5'h0A;
            Rd_write_byte_en_Mem = 4'b1111;
            RegWrite_Mem = 1;
            WBData_Mem = 32'h1234_5678;

            @(negedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_BBBB, 1, 5'h0A, 4'b1111, 1, 32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stall Operation", test_num);
            reset_dut();


            stall = 0;
            flush = 0;
            MemData_Mem = 32'h1111_1111;
            MemRead_Mem = 0;
            Rd_Mem = 5'h01;
            Rd_write_byte_en_Mem = 4'b0001;
            RegWrite_Mem = 1;
            WBData_Mem = 32'h8888_8888;
            @(negedge clk);
            #2;


            stall = 1;
            MemData_Mem = 32'hFFFF_FFFF;
            WBData_Mem = 32'h0000_0000;
            Rd_Mem = 5'h1F;
            @(negedge clk);
            #2;


            #1;



            check_outputs(32'h1111_1111, 0, 5'h01, 4'b0001, 1, 32'h8888_8888);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Operation", test_num);
            reset_dut();


            stall = 0;
            flush = 0;
            MemData_Mem = 32'hCAFE_BABE;
            Rd_Mem = 5'h10;
            @(negedge clk);
            #2;


            flush = 1;
            @(negedge clk);
            #2;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush priority over Stall", test_num);
            reset_dut();


            stall = 0;
            flush = 0;
            MemData_Mem = 32'h5555_6666;
            @(negedge clk);
            #2;


            stall = 1;
            flush = 1;
            MemData_Mem = 32'h9999_9999;
            @(negedge clk);
            #2;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Updates", test_num);
            reset_dut();

            stall = 0;
            flush = 0;


            MemData_Mem = 32'h0000_0001;
            Rd_Mem = 5'd1;
            @(negedge clk);
            #2;


            MemData_Mem = 32'h0000_0002;
            Rd_Mem = 5'd2;
            @(negedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0002, 0, 5'd2, 0, 0, 0);
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
        input [31:0] expected_MemData_Wr;
        input expected_MemRead_Wr;
        input [4:0] expected_Rd_Wr;
        input [3:0] expected_Rd_write_byte_en_Wr;
        input expected_RegWrite_Wr;
        input [31:0] expected_WBData_Wr;
        begin
            if (expected_MemData_Wr === (expected_MemData_Wr ^ MemData_Wr ^ expected_MemData_Wr) &&
                expected_MemRead_Wr === (expected_MemRead_Wr ^ MemRead_Wr ^ expected_MemRead_Wr) &&
                expected_Rd_Wr === (expected_Rd_Wr ^ Rd_Wr ^ expected_Rd_Wr) &&
                expected_Rd_write_byte_en_Wr === (expected_Rd_write_byte_en_Wr ^ Rd_write_byte_en_Wr ^ expected_Rd_write_byte_en_Wr) &&
                expected_RegWrite_Wr === (expected_RegWrite_Wr ^ RegWrite_Wr ^ expected_RegWrite_Wr) &&
                expected_WBData_Wr === (expected_WBData_Wr ^ WBData_Wr ^ expected_WBData_Wr)) begin
                $display("PASS");
                $display("  Outputs: MemData_Wr=%h, MemRead_Wr=%b, Rd_Wr=%h, Rd_write_byte_en_Wr=%h, RegWrite_Wr=%b, WBData_Wr=%h",
                         MemData_Wr, MemRead_Wr, Rd_Wr, Rd_write_byte_en_Wr, RegWrite_Wr, WBData_Wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemData_Wr=%h, MemRead_Wr=%b, Rd_Wr=%h, Rd_write_byte_en_Wr=%h, RegWrite_Wr=%b, WBData_Wr=%h",
                         expected_MemData_Wr, expected_MemRead_Wr, expected_Rd_Wr, expected_Rd_write_byte_en_Wr, expected_RegWrite_Wr, expected_WBData_Wr);
                $display("  Got:      MemData_Wr=%h, MemRead_Wr=%b, Rd_Wr=%h, Rd_write_byte_en_Wr=%h, RegWrite_Wr=%b, WBData_Wr=%h",
                         MemData_Wr, MemRead_Wr, Rd_Wr, Rd_write_byte_en_Wr, RegWrite_Wr, WBData_Wr);
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
        $dumpvars(0,MemData_Mem, MemRead_Mem, Rd_Mem, Rd_write_byte_en_Mem, RegWrite_Mem, WBData_Mem, clk, flush, stall, MemData_Wr, MemRead_Wr, Rd_Wr, Rd_write_byte_en_Wr, RegWrite_Wr, WBData_Wr);
    end

endmodule
