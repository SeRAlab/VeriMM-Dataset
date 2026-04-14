`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUresult;
    reg clk;
    reg [31:0] ctrl;
    reg [31:0] op2;
    reg [31:0] pcin2;
    reg [4:0] rd;
    wire [31:0] bm;
    wire [31:0] ctrlm;
    wire [31:0] pcin3;
    wire [4:0] rdm;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresult(ALUresult),
        .clk(clk),
        .ctrl(ctrl),
        .op2(op2),
        .pcin2(pcin2),
        .rd(rd),
        .bm(bm),
        .ctrlm(ctrlm),
        .pcin3(pcin3),
        .rdm(rdm),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ALUresult = 32'h0;
        op2 = 32'h0;
        ctrl = 32'h0;
        pcin2 = 32'h0;
        rd = 5'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Basic Data Propagation", test_num);
        reset_dut();

        ALUresult = 32'h12345678;
        op2       = 32'h87654321;
        ctrl      = 32'hAAAAAAAA;
        pcin2     = 32'h00001004;
        rd        = 5'd15;

        @(posedge clk);
        #2;



        #1;




        check_outputs(32'h87654321, 32'hAAAAAAAA, 32'h00001004, 5'd15, 32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: All Zeros", test_num);
        reset_dut();

        ALUresult = 32'h0;
        op2       = 32'h0;
        ctrl      = 32'h0;
        pcin2     = 32'h0;
        rd        = 5'h0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0, 5'h0, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: All Ones", test_num);
        reset_dut();

        ALUresult = 32'hFFFFFFFF;
        op2       = 32'hFFFFFFFF;
        ctrl      = 32'hFFFFFFFF;
        pcin2     = 32'hFFFFFFFF;
        rd        = 5'h1F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 5'h1F, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Rapid Sequential Change", test_num);
        reset_dut();


        ALUresult = 32'hA1A1A1A1;
        op2       = 32'hB2B2B2B2;
        ctrl      = 32'hC3C3C3C3;
        pcin2     = 32'hD4D4D4D4;
        rd        = 5'd10;

        @(posedge clk);
        #1;

        ALUresult = 32'h0;

        #1;
        #1;

        check_outputs(32'hB2B2B2B2, 32'hC3C3C3C3, 32'hD4D4D4D4, 5'd10, 32'hA1A1A1A1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
        reset_dut();

        ALUresult = 32'h55555555;
        op2       = 32'hAAAAAAAA;
        ctrl      = 32'h5A5A5A5A;
        pcin2     = 32'hA5A5A5A5;
        rd        = 5'd31;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAAAAAA, 32'h5A5A5A5A, 32'hA5A5A5A5, 5'd31, 32'h55555555);
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
        input [31:0] expected_bm;
        input [31:0] expected_ctrlm;
        input [31:0] expected_pcin3;
        input [4:0] expected_rdm;
        input [31:0] expected_y;
        begin
            if (expected_bm === (expected_bm ^ bm ^ expected_bm) &&
                expected_ctrlm === (expected_ctrlm ^ ctrlm ^ expected_ctrlm) &&
                expected_pcin3 === (expected_pcin3 ^ pcin3 ^ expected_pcin3) &&
                expected_rdm === (expected_rdm ^ rdm ^ expected_rdm) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: bm=%h, ctrlm=%h, pcin3=%h, rdm=%h, y=%h",
                         bm, ctrlm, pcin3, rdm, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bm=%h, ctrlm=%h, pcin3=%h, rdm=%h, y=%h",
                         expected_bm, expected_ctrlm, expected_pcin3, expected_rdm, expected_y);
                $display("  Got:      bm=%h, ctrlm=%h, pcin3=%h, rdm=%h, y=%h",
                         bm, ctrlm, pcin3, rdm, y);
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
        $dumpvars(0,ALUresult, clk, ctrl, op2, pcin2, rd, bm, ctrlm, pcin3, rdm, y);
    end

endmodule
