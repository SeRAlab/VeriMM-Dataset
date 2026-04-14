`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Addr;
    reg [31:0] DataOut;
    reg MemtoReg;
    reg Overflow;
    reg RegWr;
    reg [4:0] Rw_in;
    reg clk;
    wire [31:0] DataIn;
    wire [4:0] Rw;
    wire WE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .DataOut(DataOut),
        .MemtoReg(MemtoReg),
        .Overflow(Overflow),
        .RegWr(RegWr),
        .Rw_in(Rw_in),
        .clk(clk),
        .DataIn(DataIn),
        .Rw(Rw),
        .WE(WE)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Addr = 32'h0;
            DataOut = 32'h0;
            MemtoReg = 1'b0;
            Overflow = 1'b0;
            RegWr = 1'b0;
            Rw_in = 5'h0;

            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Memory to Register Write (MemtoReg=1, RegWr=1, Overflow=0)", test_num);
            reset_dut();

            Addr     = 32'h1234_5678;
            DataOut  = 32'hDEAD_BEEF;
            MemtoReg = 1'b1;
            Overflow = 1'b0;
            RegWr    = 1'b1;
            Rw_in    = 5'd15;


            @(negedge clk);
            #2;


            #1;



            check_outputs(32'hDEAD_BEEF, 5'd15, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: ALU to Register Write (MemtoReg=0, RegWr=1, Overflow=0)", test_num);
            reset_dut();

            Addr     = 32'hAAAA_5555;
            DataOut  = 32'hFFFF_FFFF;
            MemtoReg = 1'b0;
            Overflow = 1'b0;
            RegWr    = 1'b1;
            Rw_in    = 5'd31;

            @(negedge clk);
            #2;


            #1;



            check_outputs(32'hAAAA_5555, 5'd31, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow inhibits WE (RegWr=1, Overflow=1)", test_num);
            reset_dut();

            Addr     = 32'h0000_1111;
            DataOut  = 32'h2222_3333;
            MemtoReg = 1'b0;
            Overflow = 1'b1;
            RegWr    = 1'b1;
            Rw_in    = 5'd10;

            @(negedge clk);
            #2;


            #1;



            check_outputs(32'h0000_1111, 5'd10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: RegWr=0 inhibits WE", test_num);
            reset_dut();

            Addr     = 32'h8888_8888;
            DataOut  = 32'h9999_9999;
            MemtoReg = 1'b1;
            Overflow = 1'b0;
            RegWr    = 1'b0;
            Rw_in    = 5'd5;

            @(negedge clk);
            #2;


            #1;



            check_outputs(32'h9999_9999, 5'd5, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Register Address 0 and MemtoReg=0", test_num);
            reset_dut();

            Addr     = 32'hCAFE_BABE;
            DataOut  = 32'hBEEF_FEED;
            MemtoReg = 1'b0;
            Overflow = 1'b0;
            RegWr    = 1'b1;
            Rw_in    = 5'd0;

            @(negedge clk);
            #2;


            #1;



            check_outputs(32'hCAFE_BABE, 5'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow=1 and RegWr=0", test_num);
            reset_dut();

            Addr     = 32'h55AA_55AA;
            DataOut  = 32'hAA55_AA55;
            MemtoReg = 1'b1;
            Overflow = 1'b1;
            RegWr    = 1'b0;
            Rw_in    = 5'd20;

            @(negedge clk);
            #2;


            #1;



            check_outputs(32'hAA55_AA55, 5'd20, 1'b0);
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
        input [31:0] expected_DataIn;
        input [4:0] expected_Rw;
        input expected_WE;
        begin
            if (expected_DataIn === (expected_DataIn ^ DataIn ^ expected_DataIn) &&
                expected_Rw === (expected_Rw ^ Rw ^ expected_Rw) &&
                expected_WE === (expected_WE ^ WE ^ expected_WE)) begin
                $display("PASS");
                $display("  Outputs: DataIn=%h, Rw=%h, WE=%b",
                         DataIn, Rw, WE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataIn=%h, Rw=%h, WE=%b",
                         expected_DataIn, expected_Rw, expected_WE);
                $display("  Got:      DataIn=%h, Rw=%h, WE=%b",
                         DataIn, Rw, WE);
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
        $dumpvars(0,Addr, DataOut, MemtoReg, Overflow, RegWr, Rw_in, clk, DataIn, Rw, WE);
    end

endmodule
