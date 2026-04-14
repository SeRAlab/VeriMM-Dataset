`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_Res_in;
    reg [3:0] Dest_in;
    reg [31:0] Val_Rm_in;
    reg WB_EN_in;
    reg clk;
    reg memory_Read_en_in;
    reg memory_write_en_in;
    reg rst;
    wire [31:0] ALU_Res_out;
    wire [3:0] Dest_out;
    wire [31:0] Val_Rm_out;
    wire WB_EN_out;
    wire memory_read_en_out;
    wire memory_write_en_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Res_in(ALU_Res_in),
        .Dest_in(Dest_in),
        .Val_Rm_in(Val_Rm_in),
        .WB_EN_in(WB_EN_in),
        .clk(clk),
        .memory_Read_en_in(memory_Read_en_in),
        .memory_write_en_in(memory_write_en_in),
        .rst(rst),
        .ALU_Res_out(ALU_Res_out),
        .Dest_out(Dest_out),
        .Val_Rm_out(Val_Rm_out),
        .WB_EN_out(WB_EN_out),
        .memory_read_en_out(memory_read_en_out),
        .memory_write_en_out(memory_write_en_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            WB_EN_in = 0;
            memory_Read_en_in = 0;
            memory_write_en_in = 0;
            ALU_Res_in = 0;
            Val_Rm_in = 0;
            Dest_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 4'h0, 32'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Capture Basic Data", test_num);
            reset_dut();

            WB_EN_in = 1'b1;
            memory_Read_en_in = 1'b0;
            memory_write_en_in = 1'b1;
            ALU_Res_in = 32'hABCD1234;
            Val_Rm_in = 32'h5555AAAA;
            Dest_in = 4'h7;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD1234, 4'h7, 32'h5555AAAA, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Capture Memory Read Signals", test_num);
            reset_dut();

            WB_EN_in = 1'b0;
            memory_Read_en_in = 1'b1;
            memory_write_en_in = 1'b0;
            ALU_Res_in = 32'hFFFFFFFF;
            Val_Rm_in = 32'h00000000;
            Dest_in = 4'hF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 4'hF, 32'h00000000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Verify No-Change Without Clock", test_num);
            reset_dut();


            WB_EN_in = 1'b1;
            ALU_Res_in = 32'h11112222;
            Dest_in = 4'h1;

            @(posedge clk);
            #1;


            WB_EN_in = 1'b0;
            ALU_Res_in = 32'h99999999;

            #5;

            #1;


            check_outputs(32'h11112222, 4'h1, 32'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Max Value and Flag Check", test_num);
            reset_dut();

            WB_EN_in = 1'b1;
            memory_Read_en_in = 1'b1;
            memory_write_en_in = 1'b1;
            ALU_Res_in = 32'h80000000;
            Val_Rm_in = 32'h7FFFFFFF;
            Dest_in = 4'h8;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000, 4'h8, 32'h7FFFFFFF, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Immediate Reset Override", test_num);
            reset_dut();


            WB_EN_in = 1'b1;
            ALU_Res_in = 32'hDEADBEEF;
            Dest_in = 4'hA;

            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 4'h0, 32'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Back-to-back Capture", test_num);
            reset_dut();


            WB_EN_in = 1; ALU_Res_in = 32'h1; Dest_in = 4'h1;
            @(posedge clk);
            #1;


            WB_EN_in = 0; ALU_Res_in = 32'h2; Dest_in = 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h2, 4'h2, 32'h0, 1'b0, 1'b0, 1'b0);
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
        input [31:0] expected_ALU_Res_out;
        input [3:0] expected_Dest_out;
        input [31:0] expected_Val_Rm_out;
        input expected_WB_EN_out;
        input expected_memory_read_en_out;
        input expected_memory_write_en_out;
        begin
            if (expected_ALU_Res_out === (expected_ALU_Res_out ^ ALU_Res_out ^ expected_ALU_Res_out) &&
                expected_Dest_out === (expected_Dest_out ^ Dest_out ^ expected_Dest_out) &&
                expected_Val_Rm_out === (expected_Val_Rm_out ^ Val_Rm_out ^ expected_Val_Rm_out) &&
                expected_WB_EN_out === (expected_WB_EN_out ^ WB_EN_out ^ expected_WB_EN_out) &&
                expected_memory_read_en_out === (expected_memory_read_en_out ^ memory_read_en_out ^ expected_memory_read_en_out) &&
                expected_memory_write_en_out === (expected_memory_write_en_out ^ memory_write_en_out ^ expected_memory_write_en_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_Res_out=%h, Dest_out=%h, Val_Rm_out=%h, WB_EN_out=%b, memory_read_en_out=%b, memory_write_en_out=%b",
                         ALU_Res_out, Dest_out, Val_Rm_out, WB_EN_out, memory_read_en_out, memory_write_en_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Res_out=%h, Dest_out=%h, Val_Rm_out=%h, WB_EN_out=%b, memory_read_en_out=%b, memory_write_en_out=%b",
                         expected_ALU_Res_out, expected_Dest_out, expected_Val_Rm_out, expected_WB_EN_out, expected_memory_read_en_out, expected_memory_write_en_out);
                $display("  Got:      ALU_Res_out=%h, Dest_out=%h, Val_Rm_out=%h, WB_EN_out=%b, memory_read_en_out=%b, memory_write_en_out=%b",
                         ALU_Res_out, Dest_out, Val_Rm_out, WB_EN_out, memory_read_en_out, memory_write_en_out);
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
        $dumpvars(0,ALU_Res_in, Dest_in, Val_Rm_in, WB_EN_in, clk, memory_Read_en_in, memory_write_en_in, rst, ALU_Res_out, Dest_out, Val_Rm_out, WB_EN_out, memory_read_en_out, memory_write_en_out);
    end

endmodule
