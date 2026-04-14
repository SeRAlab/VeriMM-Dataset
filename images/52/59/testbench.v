`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Bit_Shift_i;
    reg Left_Right_i;
    reg [31:0] Shift_Data_i;
    reg [31:0] Shift_Value_i;
    reg clk;
    reg load_i;
    reg rst;
    wire [31:0] N_mant_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bit_Shift_i(Bit_Shift_i),
        .Left_Right_i(Left_Right_i),
        .Shift_Data_i(Shift_Data_i),
        .Shift_Value_i(Shift_Value_i),
        .clk(clk),
        .load_i(load_i),
        .rst(rst),
        .N_mant_o(N_mant_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load_i = 0;
            Shift_Data_i = 0;
            Shift_Value_i = 0;
            Left_Right_i = 0;
            Bit_Shift_i = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Shift_Data_i = 32'h00000001;
            Shift_Value_i = 32'd4;
            Left_Right_i = 1;
            Bit_Shift_i = 0;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Shift_Data_i = 32'h80000000;
            Shift_Value_i = 32'd4;
            Left_Right_i = 0;
            Bit_Shift_i = 0;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h08000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Shift_Data_i = 32'h80000000;
            Shift_Value_i = 32'd4;
            Left_Right_i = 0;
            Bit_Shift_i = 1;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'hF8000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Shift_Data_i = 32'h70000000;
            Shift_Value_i = 32'd4;
            Left_Right_i = 0;
            Bit_Shift_i = 1;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h07000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Shift_Data_i = 32'hABCDE123;
            Shift_Value_i = 32'd0;
            Left_Right_i = 1;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'hABCDE123);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Shift_Data_i = 32'h00000001;
            Shift_Value_i = 32'd31;
            Left_Right_i = 1;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            Shift_Data_i = 32'h80000000;
            Shift_Value_i = 32'd31;
            Left_Right_i = 0;
            Bit_Shift_i = 0;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            Shift_Data_i = 32'h80000000;
            Shift_Value_i = 32'd31;
            Left_Right_i = 0;
            Bit_Shift_i = 1;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            Shift_Data_i = 32'hFFFFFFFF;
            Shift_Value_i = 32'd32;
            Left_Right_i = 0;
            Bit_Shift_i = 0;
            load_i = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            Shift_Data_i = 32'hFFFFFFFF;
            Shift_Value_i = 32'd4;
            load_i = 1;
            rst = 1;
            @(posedge clk);
            #2 #1;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_N_mant_o;
        begin
            if (expected_N_mant_o === (expected_N_mant_o ^ N_mant_o ^ expected_N_mant_o)) begin
                $display("PASS");
                $display("  Outputs: N_mant_o=%h",
                         N_mant_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N_mant_o=%h",
                         expected_N_mant_o);
                $display("  Got:      N_mant_o=%h",
                         N_mant_o);
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
        $dumpvars(0,Bit_Shift_i, Left_Right_i, Shift_Data_i, Shift_Value_i, clk, load_i, rst, N_mant_o);
    end

endmodule
