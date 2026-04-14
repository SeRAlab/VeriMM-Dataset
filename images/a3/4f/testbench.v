`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ReadData_i;
    reg [1:0] WB_i;
    reg clk_i;
    reg [31:0] immed_i;
    reg [4:0] mux3_i;
    reg stall_i;
    wire [31:0] ReadData_o;
    wire [1:0] WB_o;
    wire [31:0] immed_o;
    wire [4:0] mux3_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadData_i(ReadData_i),
        .WB_i(WB_i),
        .clk_i(clk_i),
        .immed_i(immed_i),
        .mux3_i(mux3_i),
        .stall_i(stall_i),
        .ReadData_o(ReadData_o),
        .WB_o(WB_o),
        .immed_o(immed_o),
        .mux3_o(mux3_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            stall_i = 0;
            WB_i = 2'b00;
            ReadData_i = 32'h0;
            mux3_i = 5'h0;
            immed_i = 32'h0;
            @(negedge clk_i);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Pass-through", test_num);
            reset_dut();

            WB_i = 2'b11;
            ReadData_i = 32'hAAAA_BBBB;
            mux3_i = 5'h15;
            immed_i = 32'h1234_5678;
            stall_i = 0;

            @(negedge clk_i);
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB, 2'b11, 32'h1234_5678, 5'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stall Functionality", test_num);
            reset_dut();


            WB_i = 2'b10;
            ReadData_i = 32'h1111_2222;
            mux3_i = 5'h0A;
            immed_i = 32'hCCCC_DDDD;
            stall_i = 0;
            @(negedge clk_i);
            #2;


            stall_i = 1;
            WB_i = 2'b01;
            ReadData_i = 32'hFFFF_FFFF;
            mux3_i = 5'h1F;
            immed_i = 32'h0000_0000;

            @(negedge clk_i);
            #2;

            #1;


            check_outputs(32'h1111_2222, 2'b10, 32'hCCCC_DDDD, 5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stall Recovery", test_num);
            reset_dut();


            stall_i = 1;
            WB_i = 2'b11;
            ReadData_i = 32'h8888_7777;
            mux3_i = 5'h05;
            immed_i = 32'h5555_4444;
            @(negedge clk_i);
            #2;


            stall_i = 0;
            @(negedge clk_i);
            #2;

            #1;


            check_outputs(32'h8888_7777, 2'b11, 32'h5555_4444, 5'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones Data", test_num);
            reset_dut();

            WB_i = 2'b11;
            ReadData_i = 32'hFFFF_FFFF;
            mux3_i = 5'h1F;
            immed_i = 32'hFFFF_FFFF;
            stall_i = 0;

            @(negedge clk_i);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 2'b11, 32'hFFFF_FFFF, 5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successive Updates", test_num);
            reset_dut();


            WB_i = 2'b01;
            ReadData_i = 32'h0000_0001;
            mux3_i = 5'h01;
            immed_i = 32'h1000_0000;
            stall_i = 0;
            @(negedge clk_i);
            #1;


            WB_i = 2'b10;
            ReadData_i = 32'h0000_0002;
            mux3_i = 5'h02;
            immed_i = 32'h2000_0000;
            @(negedge clk_i);
            #2;

            #1;


            check_outputs(32'h0000_0002, 2'b10, 32'h2000_0000, 5'h02);
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
        input [31:0] expected_ReadData_o;
        input [1:0] expected_WB_o;
        input [31:0] expected_immed_o;
        input [4:0] expected_mux3_o;
        begin
            if (expected_ReadData_o === (expected_ReadData_o ^ ReadData_o ^ expected_ReadData_o) &&
                expected_WB_o === (expected_WB_o ^ WB_o ^ expected_WB_o) &&
                expected_immed_o === (expected_immed_o ^ immed_o ^ expected_immed_o) &&
                expected_mux3_o === (expected_mux3_o ^ mux3_o ^ expected_mux3_o)) begin
                $display("PASS");
                $display("  Outputs: ReadData_o=%h, WB_o=%h, immed_o=%h, mux3_o=%h",
                         ReadData_o, WB_o, immed_o, mux3_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData_o=%h, WB_o=%h, immed_o=%h, mux3_o=%h",
                         expected_ReadData_o, expected_WB_o, expected_immed_o, expected_mux3_o);
                $display("  Got:      ReadData_o=%h, WB_o=%h, immed_o=%h, mux3_o=%h",
                         ReadData_o, WB_o, immed_o, mux3_o);
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
        $dumpvars(0,ReadData_i, WB_i, clk_i, immed_i, mux3_i, stall_i, ReadData_o, WB_o, immed_o, mux3_o);
    end

endmodule
