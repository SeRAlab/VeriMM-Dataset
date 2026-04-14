`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clrn;
    reg [31:0] d;
    reg [4:0] rna;
    reg [4:0] rnb;
    reg we;
    reg [4:0] wn;
    wire [31:0] qa;
    wire [31:0] qb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clrn(clrn),
        .d(d),
        .rna(rna),
        .rnb(rnb),
        .we(we),
        .wn(wn),
        .qa(qa),
        .qb(qb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clrn = 0;
        we = 0;
        rna = 0;
        rnb = 0;
        wn = 0;
        d = 0;
        #12;
        clrn = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write/Read reg 5", test_num);
        reset_dut();
        @(negedge clk);
        we = 1; wn = 5; d = 32'hA5A5A5A5;
        @(negedge clk);
        we = 0; rna = 5; rnb = 5;
        #2;
        #1;

        check_outputs(32'hA5A5A5A5, 32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Register 0 should always be 0", test_num);
        reset_dut();
        @(negedge clk);
        we = 1; wn = 0; d = 32'hFFFFFFFF;
        @(negedge clk);
        we = 0; rna = 0; rnb = 0;
        #2;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Dual port simultaneous read", test_num);
        reset_dut();
        @(negedge clk);
        we = 1; wn = 10; d = 32'h12345678;
        @(negedge clk);
        we = 1; wn = 20; d = 32'h87654321;
        @(negedge clk);
        we = 0; rna = 10; rnb = 20;
        #2;
        #1;

        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Asynchronous clear check", test_num);
        reset_dut();
        @(negedge clk);
        we = 1; wn = 15; d = 32'hDEADBEEF;
        @(negedge clk);
        we = 0; rna = 15; rnb = 15;
        #2;
        clrn = 0;
        #2;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
        clrn = 1;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Enable (we=0) check", test_num);
        reset_dut();
        @(negedge clk);
        we = 0; wn = 7; d = 32'hCAFEBABE;
        @(negedge clk);
        rna = 7; rnb = 7;
        #2;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write then immediate read next cycle", test_num);
        reset_dut();
        @(negedge clk);
        we = 1; wn = 31; d = 32'h55AA55AA;
        @(negedge clk);
        we = 0; rna = 31; rnb = 0;
        #2;
        #1;

        check_outputs(32'h55AA55AA, 32'h00000000);
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
        input [31:0] expected_qa;
        input [31:0] expected_qb;
        begin
            if (expected_qa === (expected_qa ^ qa ^ expected_qa) &&
                expected_qb === (expected_qb ^ qb ^ expected_qb)) begin
                $display("PASS");
                $display("  Outputs: qa=%h, qb=%h",
                         qa, qb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qa=%h, qb=%h",
                         expected_qa, expected_qb);
                $display("  Got:      qa=%h, qb=%h",
                         qa, qb);
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
        $dumpvars(0,clk, clrn, d, rna, rnb, we, wn, qa, qb);
    end

endmodule
