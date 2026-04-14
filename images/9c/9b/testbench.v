`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] if_is;
    reg [31:0] if_pc;
    reg mmif_ok;
    reg rst;
    reg stl_mm;
    wire [31:0] id_is;
    wire [31:0] id_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .if_is(if_is),
        .if_pc(if_pc),
        .mmif_ok(mmif_ok),
        .rst(rst),
        .stl_mm(stl_mm),
        .id_is(id_is),
        .id_pc(id_pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        stl_mm = 0;
        if_pc = 32'h0;
        if_is = 32'h0;
        mmif_ok = 1;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify reset state", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Normal data capture (no stall)", test_num);
        reset_dut();

        if_pc = 32'h0000_1000;
        if_is = 32'h3C01_A000;
        stl_mm = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h3C01_A000, 32'h0000_1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stall logic (stl_mm active)", test_num);
        reset_dut();


        if_pc = 32'h0000_2000;
        if_is = 32'h0000_0001;
        stl_mm = 0;
        @(posedge clk);
        #1;


        stl_mm = 1;
        if_pc = 32'hFFFF_FFFF;
        if_is = 32'hEEEE_EEEE;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h0000_0001, 32'h0000_2000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Resume after stall", test_num);
        reset_dut();


        if_pc = 32'h1111_1111; if_is = 32'hAAAA_AAAA;
        @(posedge clk);
        #1;


        stl_mm = 1;
        if_pc = 32'h2222_2222; if_is = 32'hBBBB_BBBB;
        @(posedge clk);
        #1;


        stl_mm = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'hBBBB_BBBB, 32'h2222_2222);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive updates", test_num);
        reset_dut();

        if_pc = 32'hA; if_is = 32'h1;
        @(posedge clk);
        #1;
        if_pc = 32'hB; if_is = 32'h2;
        @(posedge clk);
        #1;
        if_pc = 32'hC; if_is = 32'h3;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h3, 32'hC);
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
        input [31:0] expected_id_is;
        input [31:0] expected_id_pc;
        begin
            if (expected_id_is === (expected_id_is ^ id_is ^ expected_id_is) &&
                expected_id_pc === (expected_id_pc ^ id_pc ^ expected_id_pc)) begin
                $display("PASS");
                $display("  Outputs: id_is=%h, id_pc=%h",
                         id_is, id_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_is=%h, id_pc=%h",
                         expected_id_is, expected_id_pc);
                $display("  Got:      id_is=%h, id_pc=%h",
                         id_is, id_pc);
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
        $dumpvars(0,clk, if_is, if_pc, mmif_ok, rst, stl_mm, id_is, id_pc);
    end

endmodule
