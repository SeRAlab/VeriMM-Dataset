`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MEM2REG_M;
    reg REGWR_M;
    reg [31:0] aludata;
    reg [31:0] memdata;
    reg [4:0] reg2wr;
    wire [31:0] din;
    wire [4:0] rw;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM2REG_M(MEM2REG_M),
        .REGWR_M(REGWR_M),
        .aludata(aludata),
        .memdata(memdata),
        .reg2wr(reg2wr),
        .din(din),
        .rw(rw),
        .we(we)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select ALU Data (MEM2REG_M=0, REGWR_M=1)", test_num);
        MEM2REG_M = 1'b0;
        REGWR_M = 1'b1;
        reg2wr = 5'd12;
        aludata = 32'hABCD_EF01;
        memdata = 32'h1234_5678;
        #1;

        check_outputs(32'hABCD_EF01, 5'd12, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select Memory Data (MEM2REG_M=1, REGWR_M=1)", test_num);
        MEM2REG_M = 1'b1;
        REGWR_M = 1'b1;
        reg2wr = 5'd25;
        aludata = 32'hAAAA_BBBB;
        memdata = 32'hCCCC_DDDD;
        #1;

        check_outputs(32'hCCCC_DDDD, 5'd25, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Write Disable (REGWR_M=0)", test_num);
        MEM2REG_M = 1'b0;
        REGWR_M = 1'b0;
        reg2wr = 5'd5;
        aludata = 32'h1111_2222;
        memdata = 32'h3333_4444;

        #1;


        check_outputs(32'h1111_2222, 5'd5, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Boundary values (Reg 0, All Fs)", test_num);
        MEM2REG_M = 1'b1;
        REGWR_M = 1'b1;
        reg2wr = 5'd0;
        aludata = 32'h0000_0000;
        memdata = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'hFFFF_FFFF, 5'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Boundary values (Reg 31, All 0s)", test_num);
        MEM2REG_M = 1'b0;
        REGWR_M = 1'b1;
        reg2wr = 5'd31;
        aludata = 32'h0000_0000;
        memdata = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000, 5'd31, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Switch MEM2REG_M dynamically", test_num);
        REGWR_M = 1'b1;
        reg2wr = 5'd15;
        aludata = 32'hDEAF_BEEF;
        memdata = 32'hCAFE_BABE;

        MEM2REG_M = 1'b0;
        #1;
        MEM2REG_M = 1'b1;
        #1;

        check_outputs(32'hCAFE_BABE, 5'd15, 1'b1);
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
        input [31:0] expected_din;
        input [4:0] expected_rw;
        input expected_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din === (expected_din ^ din ^ expected_din) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: din=%h, rw=%h, we=%b",
                         din, rw, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din=%h, rw=%h, we=%b",
                         expected_din, expected_rw, expected_we);
                $display("  Got:      din=%h, rw=%h, we=%b",
                         din, rw, we);
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

endmodule
