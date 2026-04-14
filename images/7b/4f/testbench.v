`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D_En;
    reg [31:0] IR;
    reg clk;
    reg [31:0] pc;
    reg [31:0] pc8;
    reg reset;
    wire [31:0] IR_D;
    wire [31:0] pc8_D;
    wire [31:0] pc_D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_En(D_En),
        .IR(IR),
        .clk(clk),
        .pc(pc),
        .pc8(pc8),
        .reset(reset),
        .IR_D(IR_D),
        .pc8_D(pc8_D),
        .pc_D(pc_D)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            D_En = 0;
            IR = 32'h0;
            pc = 32'h0;
            pc8 = 32'h0;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset = 1;
            D_En = 0;
            IR = 32'hAAAAAAAA;
            pc = 32'hBBBBBBBB;
            pc8 = 32'hCCCCCCCC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Update (D_En=0)", test_num);
            reset_dut();

            IR = 32'h12345678;
            pc = 32'h00001000;
            pc8 = 32'h00001008;
            D_En = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 32'h00001008, 32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Operation (D_En=1)", test_num);
            reset_dut();


            IR = 32'hDEADBEEF;
            pc = 32'h00002000;
            pc8 = 32'h00002008;
            D_En = 0;
            @(posedge clk);
            #2;


            D_En = 1;
            IR = 32'hFFFFFFFF;
            pc = 32'hFFFFFFFF;
            pc8 = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hDEADBEEF, 32'h00002008, 32'h00002000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Updates", test_num);
            reset_dut();

            D_En = 0;
            IR = 32'h11111111; pc = 32'h00000100; pc8 = 32'h00000108;
            @(posedge clk);
            #2;

            IR = 32'h22222222; pc = 32'h00000200; pc8 = 32'h00000208;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h22222222, 32'h00000208, 32'h00000200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over D_En", test_num);
            reset_dut();


            IR = 32'h88888888; pc = 32'h00008000; pc8 = 32'h00008008;
            D_En = 0;
            @(posedge clk);
            #2;


            reset = 1;
            D_En = 1;
            IR = 32'h99999999;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h0, 32'h0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold to Update Transition", test_num);
            reset_dut();


            IR = 32'hAAAA0000; pc = 32'h100; pc8 = 32'h108;
            D_En = 0;
            @(posedge clk);
            #2;

            D_En = 1;
            IR = 32'hBBBB1111;
            @(posedge clk);
            #2;


            D_En = 0;
            IR = 32'hCCCC2222;
            pc = 32'h300;
            pc8 = 32'h308;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCCCC2222, 32'h308, 32'h300);
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
        input [31:0] expected_IR_D;
        input [31:0] expected_pc8_D;
        input [31:0] expected_pc_D;
        begin
            if (expected_IR_D === (expected_IR_D ^ IR_D ^ expected_IR_D) &&
                expected_pc8_D === (expected_pc8_D ^ pc8_D ^ expected_pc8_D) &&
                expected_pc_D === (expected_pc_D ^ pc_D ^ expected_pc_D)) begin
                $display("PASS");
                $display("  Outputs: IR_D=%h, pc8_D=%h, pc_D=%h",
                         IR_D, pc8_D, pc_D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IR_D=%h, pc8_D=%h, pc_D=%h",
                         expected_IR_D, expected_pc8_D, expected_pc_D);
                $display("  Got:      IR_D=%h, pc8_D=%h, pc_D=%h",
                         IR_D, pc8_D, pc_D);
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
        $dumpvars(0,D_En, IR, clk, pc, pc8, reset, IR_D, pc8_D, pc_D);
    end

endmodule
