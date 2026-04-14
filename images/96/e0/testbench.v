`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;
    reg clk;
    reg reset;
    wire [31:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .WD(WD),
        .WE(WE),
        .clk(clk),
        .reset(reset),
        .RD(RD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        A = 0;
        WD = 0;
        WE = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Post-reset Initialization Check", test_num);
        reset_dut();

        A = 32'd2;
        WE = 0;
        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Write/Read (Addr 0)", test_num);
        reset_dut();


        A = 32'd0;
        WD = 32'hABCDEFFF;
        WE = 1;
        @(posedge clk);
        #1;


        WE = 0;
        #2;
        #1;

        check_outputs(32'hABCDEFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Basic Write/Read (Addr 4)", test_num);
        reset_dut();


        A = 32'd4;
        WD = 32'h12345678;
        WE = 1;
        @(posedge clk);
        #1;


        WE = 0;
        #2;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: RD Default to 0 during Write", test_num);
        reset_dut();


        A = 32'd1;
        WD = 32'h5555AAAA;
        WE = 1;
        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overwrite Check", test_num);
        reset_dut();


        A = 32'd3;
        WD = 32'hAAAAAAAA;
        WE = 1;
        @(posedge clk);
        #1;


        WD = 32'hBBBBBBBB;
        WE = 1;
        @(posedge clk);
        #1;


        WE = 0;
        #2;
        #1;

        check_outputs(32'hBBBBBBBB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: RD Default to 0 during Reset", test_num);
        reset_dut();


        A = 32'd0;
        WD = 32'hFFFFFFFF;
        WE = 1;
        @(posedge clk);
        #1;


        reset = 1;
        WE = 0;
        #2;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_RD;
        begin
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
        $dumpvars(0,A, WD, WE, clk, reset, RD);
    end

endmodule
