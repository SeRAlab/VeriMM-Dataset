`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Flush_i;
    reg Hazard_i;
    reg clk_i;
    reg [31:0] inst_i;
    reg [31:0] pc_i;
    reg stall_i;
    wire [31:0] inst_o;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Flush_i(Flush_i),
        .Hazard_i(Hazard_i),
        .clk_i(clk_i),
        .inst_i(inst_i),
        .pc_i(pc_i),
        .stall_i(stall_i),
        .inst_o(inst_o),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        Flush_i = 1;
        Hazard_i = 0;
        stall_i = 0;
        pc_i = 32'h0;
        inst_i = 32'h0;
        @(posedge clk_i);
        #1;
        Flush_i = 0;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        pc_i = 32'h0000_1000;
        inst_i = 32'h0123_4567;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Normal Propagation", test_num);
        #1;

        check_outputs(32'h0123_4567, 32'h0000_1000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        pc_i = 32'h0000_2000;
        inst_i = 32'hAAAA_BBBB;
        @(posedge clk_i);
        #1;

        stall_i = 1;
        pc_i = 32'h0000_2004;
        inst_i = 32'hCCCC_DDDD;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Stall (stall_i)", test_num);
        #1;

        check_outputs(32'hAAAA_BBBB, 32'h0000_2000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        pc_i = 32'h0000_3000;
        inst_i = 32'h1111_2222;
        @(posedge clk_i);
        #1;

        Hazard_i = 1;
        pc_i = 32'h0000_3004;
        inst_i = 32'h3333_4444;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Hazard (Hazard_i)", test_num);
        #1;

        check_outputs(32'h1111_2222, 32'h0000_3000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        pc_i = 32'h0000_4000;
        inst_i = 32'hFFFF_FFFF;
        @(posedge clk_i);
        #1;

        Flush_i = 1;
        pc_i = 32'h0000_4004;
        inst_i = 32'hEEEE_EEEE;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Flush Instruction", test_num);

        #1;


        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        pc_i = 32'h0000_5000;
        inst_i = 32'h5555_6666;
        @(posedge clk_i);
        #1;

        Hazard_i = 1;
        Flush_i = 1;
        pc_i = 32'h0000_5004;
        inst_i = 32'h7777_8888;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Flush Priority over Hazard", test_num);
        #1;

        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        pc_i = 32'hA; inst_i = 32'h1;
        @(posedge clk_i);
        #1;
        pc_i = 32'hB; inst_i = 32'h2;
        @(posedge clk_i);
        #1;
        pc_i = 32'hC; inst_i = 32'h3;
        @(posedge clk_i);
        #1;
        $display("Testcase %0d: Sequential Stream", test_num);
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
        input [31:0] expected_inst_o;
        input [31:0] expected_pc_o;
        begin
            if (expected_inst_o === (expected_inst_o ^ inst_o ^ expected_inst_o) &&
                expected_pc_o === (expected_pc_o ^ pc_o ^ expected_pc_o)) begin
                $display("PASS");
                $display("  Outputs: inst_o=%h, pc_o=%h",
                         inst_o, pc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst_o=%h, pc_o=%h",
                         expected_inst_o, expected_pc_o);
                $display("  Got:      inst_o=%h, pc_o=%h",
                         inst_o, pc_o);
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
        $dumpvars(0,Flush_i, Hazard_i, clk_i, inst_i, pc_i, stall_i, inst_o, pc_o);
    end

endmodule
