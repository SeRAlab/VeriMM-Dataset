`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg [31:0] mmu_bad_addr_new;
    reg mmu_bad_addr_we;
    reg [31:0] psw_new;
    reg psw_we;
    reg reset;
    reg [2:0] rn;
    reg [31:0] tlb_entry_hi_new;
    reg tlb_entry_hi_we;
    reg [31:0] tlb_entry_lo_new;
    reg tlb_entry_lo_we;
    reg [31:0] tlb_index_new;
    reg tlb_index_we;
    reg we;
    wire [31:0] dout;
    wire [31:0] mmu_bad_addr;
    wire [31:0] psw;
    wire [31:0] tlb_entry_hi;
    wire [31:0] tlb_entry_lo;
    wire [31:0] tlb_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .mmu_bad_addr_new(mmu_bad_addr_new),
        .mmu_bad_addr_we(mmu_bad_addr_we),
        .psw_new(psw_new),
        .psw_we(psw_we),
        .reset(reset),
        .rn(rn),
        .tlb_entry_hi_new(tlb_entry_hi_new),
        .tlb_entry_hi_we(tlb_entry_hi_we),
        .tlb_entry_lo_new(tlb_entry_lo_new),
        .tlb_entry_lo_we(tlb_entry_lo_we),
        .tlb_index_new(tlb_index_new),
        .tlb_index_we(tlb_index_we),
        .we(we),
        .dout(dout),
        .mmu_bad_addr(mmu_bad_addr),
        .psw(psw),
        .tlb_entry_hi(tlb_entry_hi),
        .tlb_entry_lo(tlb_entry_lo),
        .tlb_index(tlb_index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            mmu_bad_addr_new = 0;
            mmu_bad_addr_we = 0;
            psw_new = 0;
            psw_we = 0;
            rn = 0;
            tlb_entry_hi_new = 0;
            tlb_entry_hi_we = 0;
            tlb_entry_lo_new = 0;
            tlb_entry_lo_we = 0;
            tlb_index_new = 0;
            tlb_index_we = 0;
            we = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: GPR Write (R1)", test_num);
            rn = 1; din = 32'h12345678; we = 1;
            @(posedge clk);
            #1;
            we = 0;
            #1;

            check_outputs(32'h12345678, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: PSW Write", test_num);
            psw_new = 32'hA5A5A5A5; psw_we = 1;
            @(posedge clk);
            #1;
            psw_we = 0;
            #1;

            check_outputs(0, 0, 32'hA5A5A5A5, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: TLB Index Write", test_num);
            tlb_index_new = 32'h0000000F; tlb_index_we = 1;
            @(posedge clk);
            #1;
            tlb_index_we = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 32'h0000000F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: TLB Entry Hi Write", test_num);
            tlb_entry_hi_new = 32'hFFFF0000; tlb_entry_hi_we = 1;
            @(posedge clk);
            #1;
            tlb_entry_hi_we = 0;
            #1;

            check_outputs(0, 0, 0, 32'hFFFF0000, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: TLB Entry Lo Write", test_num);
            tlb_entry_lo_new = 32'h0000FFFF; tlb_entry_lo_we = 1;
            @(posedge clk);
            #1;
            tlb_entry_lo_we = 0;
            #1;

            check_outputs(0, 0, 0, 0, 32'h0000FFFF, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: MMU Bad Addr Write", test_num);
            mmu_bad_addr_new = 32'hDEADBEEF; mmu_bad_addr_we = 1;
            @(posedge clk);
            #1;
            mmu_bad_addr_we = 0;
            #1;

            check_outputs(0, 32'hDEADBEEF, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: GPR Write Protection Check (we=0)", test_num);
            rn = 2; din = 32'hCAFEBABE; we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Sequential GPR Reads (R3 and R5)", test_num);

            rn = 3; din = 32'h33333333; we = 1;
            @(posedge clk); #1;

            rn = 5; din = 32'h55555555; we = 1;
            @(posedge clk); #1;

            we = 0; rn = 3;
            #1;
            #1;

            check_outputs(32'h33333333, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Global Simultaneous Write (GPR + all SPRs)", test_num);
            rn = 7; din = 32'h77777777; we = 1;
            psw_new = 32'h01; psw_we = 1;
            tlb_index_new = 32'h02; tlb_index_we = 1;
            tlb_entry_hi_new = 32'h03; tlb_entry_hi_we = 1;
            tlb_entry_lo_new = 32'h04; tlb_entry_lo_we = 1;
            mmu_bad_addr_new = 32'h05; mmu_bad_addr_we = 1;
            @(posedge clk);
            #1;
            we = 0; psw_we = 0; tlb_index_we = 0; tlb_entry_hi_we = 0; tlb_entry_lo_we = 0; mmu_bad_addr_we = 0;
            rn = 7;
            #1;
            #1;

            check_outputs(32'h77777777, 32'h05, 32'h01, 32'h03, 32'h04, 32'h02);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_dout;
        input [31:0] expected_mmu_bad_addr;
        input [31:0] expected_psw;
        input [31:0] expected_tlb_entry_hi;
        input [31:0] expected_tlb_entry_lo;
        input [31:0] expected_tlb_index;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_mmu_bad_addr === (expected_mmu_bad_addr ^ mmu_bad_addr ^ expected_mmu_bad_addr) &&
                expected_psw === (expected_psw ^ psw ^ expected_psw) &&
                expected_tlb_entry_hi === (expected_tlb_entry_hi ^ tlb_entry_hi ^ expected_tlb_entry_hi) &&
                expected_tlb_entry_lo === (expected_tlb_entry_lo ^ tlb_entry_lo ^ expected_tlb_entry_lo) &&
                expected_tlb_index === (expected_tlb_index ^ tlb_index ^ expected_tlb_index)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, mmu_bad_addr=%h, psw=%h, tlb_entry_hi=%h, tlb_entry_lo=%h, tlb_index=%h",
                         dout, mmu_bad_addr, psw, tlb_entry_hi, tlb_entry_lo, tlb_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, mmu_bad_addr=%h, psw=%h, tlb_entry_hi=%h, tlb_entry_lo=%h, tlb_index=%h",
                         expected_dout, expected_mmu_bad_addr, expected_psw, expected_tlb_entry_hi, expected_tlb_entry_lo, expected_tlb_index);
                $display("  Got:      dout=%h, mmu_bad_addr=%h, psw=%h, tlb_entry_hi=%h, tlb_entry_lo=%h, tlb_index=%h",
                         dout, mmu_bad_addr, psw, tlb_entry_hi, tlb_entry_lo, tlb_index);
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
        $dumpvars(0,clk, din, mmu_bad_addr_new, mmu_bad_addr_we, psw_new, psw_we, reset, rn, tlb_entry_hi_new, tlb_entry_hi_we, tlb_entry_lo_new, tlb_entry_lo_we, tlb_index_new, tlb_index_we, we, dout, mmu_bad_addr, psw, tlb_entry_hi, tlb_entry_lo, tlb_index);
    end

endmodule
