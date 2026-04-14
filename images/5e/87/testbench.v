`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_imem_ram_i;
    reg clk;
    reg wr_en_imem_ram_i;
    reg [31:0] wr_instr_imem_ram_i;
    wire [31:0] read_instr_imem_ram_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_imem_ram_i(addr_imem_ram_i),
        .clk(clk),
        .wr_en_imem_ram_i(wr_en_imem_ram_i),
        .wr_instr_imem_ram_i(wr_instr_imem_ram_i),
        .read_instr_imem_ram_o(read_instr_imem_ram_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_imem_ram_i = 0;
            wr_en_imem_ram_i = 0;
            wr_instr_imem_ram_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Basic Write and Read at Address 0");
            wr_instr_imem_ram_i = 32'hAABBCCDD;
            addr_imem_ram_i = 32'h0;
            wr_en_imem_ram_i = 1;
            @(posedge clk);
            #1;
            wr_en_imem_ram_i = 0;
            addr_imem_ram_i = 32'h0;
            #1;
            #1;

            check_outputs(32'hAABBCCDD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Basic Write and Read at Address 4");
            wr_instr_imem_ram_i = 32'h12345678;
            addr_imem_ram_i = 32'h4;
            wr_en_imem_ram_i = 1;
            @(posedge clk);
            #1;
            wr_en_imem_ram_i = 0;
            addr_imem_ram_i = 32'h4;
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Alignment Check (Writing to 0x8, Reading 0x9/0xA/0xB)");
            wr_instr_imem_ram_i = 32'hCAFEBABE;
            addr_imem_ram_i = 32'h8;
            wr_en_imem_ram_i = 1;
            @(posedge clk);
            #1;
            wr_en_imem_ram_i = 0;


            addr_imem_ram_i = 32'hB;
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Verify Write Enable (Attempting write with wr_en=0)");


            wr_instr_imem_ram_i = 32'h11111111;
            addr_imem_ram_i = 32'h10;
            wr_en_imem_ram_i = 1;
            @(posedge clk);
            #1;


            wr_instr_imem_ram_i = 32'h99999999;
            wr_en_imem_ram_i = 0;
            @(posedge clk);
            #1;

            addr_imem_ram_i = 32'h10;
            #1;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Boundary Check (Last Word at 0x1FFC)");
            wr_instr_imem_ram_i = 32'hDEADBEEF;
            addr_imem_ram_i = 32'h1FFC;
            wr_en_imem_ram_i = 1;
            @(posedge clk);
            #1;
            wr_en_imem_ram_i = 0;
            addr_imem_ram_i = 32'h1FFC;
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_read_instr_imem_ram_o;
        begin
            if (expected_read_instr_imem_ram_o === (expected_read_instr_imem_ram_o ^ read_instr_imem_ram_o ^ expected_read_instr_imem_ram_o)) begin
                $display("PASS");
                $display("  Outputs: read_instr_imem_ram_o=%h",
                         read_instr_imem_ram_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_instr_imem_ram_o=%h",
                         expected_read_instr_imem_ram_o);
                $display("  Got:      read_instr_imem_ram_o=%h",
                         read_instr_imem_ram_o);
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
        $dumpvars(0,addr_imem_ram_i, clk, wr_en_imem_ram_i, wr_instr_imem_ram_i, read_instr_imem_ram_o);
    end

endmodule
