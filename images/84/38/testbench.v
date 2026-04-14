`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BJ;
    reg clk;
    reg [31:0] if_instr;
    reg [31:0] if_pcplus4;
    reg rst;
    reg stall;
    wire [31:0] id_instr;
    wire [31:0] id_pcplus4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BJ(BJ),
        .clk(clk),
        .if_instr(if_instr),
        .if_pcplus4(if_pcplus4),
        .rst(rst),
        .stall(stall),
        .id_instr(id_instr),
        .id_pcplus4(id_pcplus4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall = 0;
            BJ = 0;
            if_instr = 32'h0;
            if_pcplus4 = 32'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal Data Capture", test_num);
            reset_dut();

            if_instr = 32'h12345678;
            if_pcplus4 = 32'h00000004;
            stall = 0;
            BJ = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Stall Mechanism", test_num);
            reset_dut();


            if_instr = 32'hAAAAAAAA;
            if_pcplus4 = 32'h00000010;
            @(posedge clk);
            #1;


            stall = 1;
            if_instr = 32'hBBBBBBBB;
            if_pcplus4 = 32'h00000020;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Branch/Jump Hold", test_num);
            reset_dut();


            if_instr = 32'h55555555;
            if_pcplus4 = 32'h00001000;
            @(posedge clk);
            #1;


            BJ = 1;
            stall = 0;
            if_instr = 32'h66666666;
            if_pcplus4 = 32'h00002000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h55555555, 32'h00001000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Resuming after Stall/BJ", test_num);
            reset_dut();


            stall = 1;
            if_instr = 32'hDEADBEEF;
            if_pcplus4 = 32'h000000A0;
            @(posedge clk);


            #1 stall = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'h000000A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous Stall and BJ", test_num);
            reset_dut();


            if_instr = 32'h11112222;
            if_pcplus4 = 32'h00000008;
            @(posedge clk);


            #1 stall = 1; BJ = 1;
            if_instr = 32'hFFFFFFFF;
            if_pcplus4 = 32'hFFFFFFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h11112222, 32'h00000008);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Sequential Flow Check", test_num);
            reset_dut();


            if_instr = 32'h00000001; if_pcplus4 = 32'h4;
            @(posedge clk);


            #1 if_instr = 32'h00000002; if_pcplus4 = 32'h8;
            @(posedge clk);


            #1 if_instr = 32'h00000003; if_pcplus4 = 32'hC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000003, 32'h0000000C);
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
        input [31:0] expected_id_instr;
        input [31:0] expected_id_pcplus4;
        begin
            if (expected_id_instr === (expected_id_instr ^ id_instr ^ expected_id_instr) &&
                expected_id_pcplus4 === (expected_id_pcplus4 ^ id_pcplus4 ^ expected_id_pcplus4)) begin
                $display("PASS");
                $display("  Outputs: id_instr=%h, id_pcplus4=%h",
                         id_instr, id_pcplus4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_instr=%h, id_pcplus4=%h",
                         expected_id_instr, expected_id_pcplus4);
                $display("  Got:      id_instr=%h, id_pcplus4=%h",
                         id_instr, id_pcplus4);
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
        $dumpvars(0,BJ, clk, if_instr, if_pcplus4, rst, stall, id_instr, id_pcplus4);
    end

endmodule
