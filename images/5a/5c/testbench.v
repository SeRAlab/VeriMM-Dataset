`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_result_in;
    reg [4:0] Dest_in;
    reg MEM_R_EN_in;
    reg [31:0] MEM_read_value_in;
    reg WB_en_in;
    reg clk;
    reg freeze;
    reg rst;
    wire [31:0] ALU_result;
    wire [4:0] Dest;
    wire MEM_R_en;
    wire [31:0] MEM_read_value;
    wire WB_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_result_in(ALU_result_in),
        .Dest_in(Dest_in),
        .MEM_R_EN_in(MEM_R_EN_in),
        .MEM_read_value_in(MEM_read_value_in),
        .WB_en_in(WB_en_in),
        .clk(clk),
        .freeze(freeze),
        .rst(rst),
        .ALU_result(ALU_result),
        .Dest(Dest),
        .MEM_R_en(MEM_R_en),
        .MEM_read_value(MEM_read_value),
        .WB_en(WB_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        freeze = 0;
        WB_en_in = 0;
        MEM_R_EN_in = 0;
        ALU_result_in = 0;
        MEM_read_value_in = 0;
        Dest_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Functionality", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0, 5'h0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Propagation (Normal Operation)", test_num);
        reset_dut();


        WB_en_in = 1;
        MEM_R_EN_in = 1;
        ALU_result_in = 32'hAAAA_BBBB;
        MEM_read_value_in = 32'h1234_5678;
        Dest_in = 5'd31;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB, 5'd31, 1'b1, 32'h1234_5678, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Freeze Mechanism", test_num);
        reset_dut();


        WB_en_in = 1;
        MEM_R_EN_in = 0;
        ALU_result_in = 32'h1111_1111;
        MEM_read_value_in = 32'h2222_2222;
        Dest_in = 5'd10;
        @(posedge clk);
        #1;


        freeze = 1;
        WB_en_in = 0;
        ALU_result_in = 32'hFFFF_FFFF;
        Dest_in = 5'd0;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h1111_1111, 5'd10, 1'b0, 32'h2222_2222, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Release Freeze", test_num);
        reset_dut();


        freeze = 1;
        WB_en_in = 1;
        ALU_result_in = 32'hCCCC_CCCC;
        @(posedge clk);


        #1 freeze = 0;
        WB_en_in = 1;
        MEM_R_EN_in = 1;
        ALU_result_in = 32'hDDDD_DDDD;
        MEM_read_value_in = 32'hEEEE_EEEE;
        Dest_in = 5'd5;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hDDDD_DDDD, 5'd5, 1'b1, 32'hEEEE_EEEE, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex Signal Sequence", test_num);
        reset_dut();


        WB_en_in = 1;
        ALU_result_in = 32'h1234_1234;
        @(posedge clk);


        #1 ALU_result_in = 32'h5678_5678;
        @(posedge clk);


        #1 rst = 1;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h0, 5'h0, 1'b0, 32'h0, 1'b0);
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
        input [31:0] expected_ALU_result;
        input [4:0] expected_Dest;
        input expected_MEM_R_en;
        input [31:0] expected_MEM_read_value;
        input expected_WB_en;
        begin
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_Dest === (expected_Dest ^ Dest ^ expected_Dest) &&
                expected_MEM_R_en === (expected_MEM_R_en ^ MEM_R_en ^ expected_MEM_R_en) &&
                expected_MEM_read_value === (expected_MEM_read_value ^ MEM_read_value ^ expected_MEM_read_value) &&
                expected_WB_en === (expected_WB_en ^ WB_en ^ expected_WB_en)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, Dest=%h, MEM_R_en=%b, MEM_read_value=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_en, MEM_read_value, WB_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, Dest=%h, MEM_R_en=%b, MEM_read_value=%h, WB_en=%b",
                         expected_ALU_result, expected_Dest, expected_MEM_R_en, expected_MEM_read_value, expected_WB_en);
                $display("  Got:      ALU_result=%h, Dest=%h, MEM_R_en=%b, MEM_read_value=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_en, MEM_read_value, WB_en);
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
        $dumpvars(0,ALU_result_in, Dest_in, MEM_R_EN_in, MEM_read_value_in, WB_en_in, clk, freeze, rst, ALU_result, Dest, MEM_R_en, MEM_read_value, WB_en);
    end

endmodule
