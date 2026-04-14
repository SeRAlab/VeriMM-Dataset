`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] MEM_ALUout;
    reg [31:0] MEM_MEMout;
    reg [1:0] MEM_WB;
    reg [4:0] MEM_rd_or_rt;
    reg clk;
    reg reset;
    wire [31:0] WB_ALUout;
    wire [31:0] WB_MEMout;
    wire [1:0] WB_WB;
    wire [4:0] WB_rd_or_rt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM_ALUout(MEM_ALUout),
        .MEM_MEMout(MEM_MEMout),
        .MEM_WB(MEM_WB),
        .MEM_rd_or_rt(MEM_rd_or_rt),
        .clk(clk),
        .reset(reset),
        .WB_ALUout(WB_ALUout),
        .WB_MEMout(WB_MEMout),
        .WB_WB(WB_WB),
        .WB_rd_or_rt(WB_rd_or_rt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            MEM_ALUout = 0;
            MEM_MEMout = 0;
            MEM_WB = 0;
            MEM_rd_or_rt = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 2'b0, 5'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Propagation", test_num);
            reset_dut();


            MEM_ALUout = 32'h12345678;
            MEM_MEMout = 32'h87654321;
            MEM_WB = 2'b10;
            MEM_rd_or_rt = 5'd15;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h12345678, 32'h87654321, 2'b10, 5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values Check", test_num);
            reset_dut();


            MEM_ALUout = 32'hFFFFFFFF;
            MEM_MEMout = 32'hFFFFFFFF;
            MEM_WB = 2'b11;
            MEM_rd_or_rt = 5'b11111;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 2'b11, 5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern Check", test_num);
            reset_dut();


            MEM_ALUout = 32'hAAAAAAAA;
            MEM_MEMout = 32'h55555555;
            MEM_WB = 2'b01;
            MEM_rd_or_rt = 5'b10101;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h55555555, 2'b01, 5'b10101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Stability Check", test_num);
            reset_dut();


            MEM_ALUout = 32'hDEADC0DE;
            MEM_MEMout = 32'h0000BEEF;
            MEM_WB = 2'b11;
            MEM_rd_or_rt = 5'd31;
            @(posedge clk);
            #2;


            MEM_ALUout = 32'h0;
            MEM_MEMout = 32'h0;
            #5;


            MEM_ALUout = 32'hA1B2C3D4;
            MEM_MEMout = 32'hE5F6A7B8;
            MEM_WB = 2'b00;
            MEM_rd_or_rt = 5'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hA1B2C3D4, 32'hE5F6A7B8, 2'b00, 5'd7);
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
        input [31:0] expected_WB_ALUout;
        input [31:0] expected_WB_MEMout;
        input [1:0] expected_WB_WB;
        input [4:0] expected_WB_rd_or_rt;
        begin
            if (expected_WB_ALUout === (expected_WB_ALUout ^ WB_ALUout ^ expected_WB_ALUout) &&
                expected_WB_MEMout === (expected_WB_MEMout ^ WB_MEMout ^ expected_WB_MEMout) &&
                expected_WB_WB === (expected_WB_WB ^ WB_WB ^ expected_WB_WB) &&
                expected_WB_rd_or_rt === (expected_WB_rd_or_rt ^ WB_rd_or_rt ^ expected_WB_rd_or_rt)) begin
                $display("PASS");
                $display("  Outputs: WB_ALUout=%h, WB_MEMout=%h, WB_WB=%h, WB_rd_or_rt=%h",
                         WB_ALUout, WB_MEMout, WB_WB, WB_rd_or_rt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_ALUout=%h, WB_MEMout=%h, WB_WB=%h, WB_rd_or_rt=%h",
                         expected_WB_ALUout, expected_WB_MEMout, expected_WB_WB, expected_WB_rd_or_rt);
                $display("  Got:      WB_ALUout=%h, WB_MEMout=%h, WB_WB=%h, WB_rd_or_rt=%h",
                         WB_ALUout, WB_MEMout, WB_WB, WB_rd_or_rt);
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
        $dumpvars(0,MEM_ALUout, MEM_MEMout, MEM_WB, MEM_rd_or_rt, clk, reset, WB_ALUout, WB_MEMout, WB_WB, WB_rd_or_rt);
    end

endmodule
