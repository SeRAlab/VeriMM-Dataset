`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CauseWrite;
    reg EPCWrite;
    reg [1:0] IntCause;
    reg clk;
    reg [31:0] pc_i;
    reg [4:0] reg_R_addr;
    reg [4:0] reg_W_addr;
    reg reg_we;
    reg rst;
    reg [31:0] wdata;
    wire [31:0] epc_o;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CauseWrite(CauseWrite),
        .EPCWrite(EPCWrite),
        .IntCause(IntCause),
        .clk(clk),
        .pc_i(pc_i),
        .reg_R_addr(reg_R_addr),
        .reg_W_addr(reg_W_addr),
        .reg_we(reg_we),
        .rst(rst),
        .wdata(wdata),
        .epc_o(epc_o),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            CauseWrite = 0;
            EPCWrite = 0;
            IntCause = 0;
            pc_i = 0;
            reg_R_addr = 0;
            reg_W_addr = 0;
            reg_we = 0;
            wdata = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            reg_R_addr = 12;
            #2;
            $display("Test %0d: Check reset state for Register 12", test_num);
            #1;

            check_outputs(epc_o, 32'h0);

            reg_R_addr = 13;
            #2;
            $display("Test %0d.1: Check reset state for Register 13", test_num);
            #1;

            check_outputs(epc_o, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            reg_we = 1;
            reg_W_addr = 12;
            wdata = 32'hDEADBEEF;
            @(posedge clk);
            reg_we = 0;
            reg_R_addr = 12;
            #2;
            $display("Test %0d: General write to Register 12", test_num);
            #1;

            check_outputs(epc_o, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            EPCWrite = 1;
            pc_i = 32'hABCD1234;
            @(posedge clk);
            EPCWrite = 0;
            reg_R_addr = 14;
            #2;
            $display("Test %0d: EPCWrite to Register 14 and epc_o check", test_num);
            #1;

            check_outputs(32'hABCD1234, 32'hABCD1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            CauseWrite = 1;
            IntCause = 2'b10;
            @(posedge clk);
            CauseWrite = 0;
            reg_R_addr = 13;
            #2;
            $display("Test %0d: CauseWrite to Register 13", test_num);
            #1;

            check_outputs(epc_o, 32'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            reg_we = 1;
            reg_W_addr = 14;
            wdata = 32'hCAFEFEED;
            @(posedge clk);
            reg_we = 0;
            reg_R_addr = 14;
            #2;
            $display("Test %0d: reg_we write to Register 14", test_num);
            #1;

            check_outputs(32'hCAFEFEED, 32'hCAFEFEED);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);

            reg_we = 1; reg_W_addr = 12; wdata = 32'h11111111;
            @(posedge clk);

            reg_we = 0; CauseWrite = 1; IntCause = 2'b11;
            @(posedge clk);

            CauseWrite = 0; EPCWrite = 1; pc_i = 32'h44444444;
            @(posedge clk);
            EPCWrite = 0;


            reg_R_addr = 13;
            #2;
            $display("Test %0d: Verification of sequence", test_num);
            #1;

            check_outputs(32'h44444444, 32'h3);
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
        input [31:0] expected_epc_o;
        input [31:0] expected_rdata;
        begin
            if (expected_epc_o === (expected_epc_o ^ epc_o ^ expected_epc_o) &&
                expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: epc_o=%h, rdata=%h",
                         epc_o, rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: epc_o=%h, rdata=%h",
                         expected_epc_o, expected_rdata);
                $display("  Got:      epc_o=%h, rdata=%h",
                         epc_o, rdata);
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
        $dumpvars(0,CauseWrite, EPCWrite, IntCause, clk, pc_i, reg_R_addr, reg_W_addr, reg_we, rst, wdata, epc_o, rdata);
    end

endmodule
