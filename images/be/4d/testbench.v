`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Count_Down;
    reg Count_Enable;
    reg Count_Load;
    reg [8:0] Load_In;
    reg Rst;
    wire Carry_Out;
    wire [8:0] Count_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Count_Down(Count_Down),
        .Count_Enable(Count_Enable),
        .Count_Load(Count_Load),
        .Load_In(Load_In),
        .Rst(Rst),
        .Carry_Out(Carry_Out),
        .Count_Out(Count_Out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Rst = 1;
        Count_Down = 0;
        Count_Enable = 0;
        Count_Load = 0;
        Load_In = 0;
        @(posedge Clk);
        #1 Rst = 0;
        @(posedge Clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Reset Check", test_num);
        #1;

        check_outputs(1'b0, 9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Count_Enable = 1;
        Count_Down = 0;
        repeat(10) @(posedge Clk);
        #1;
        $display("Test %0d: Simple Increment to 10", test_num);
        #1;

        check_outputs(1'b0, 9'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        Load_In = 9'd50;
        Count_Load = 1;
        @(posedge Clk);
        #1 Count_Load = 0;
        Count_Enable = 1;
        Count_Down = 1;
        repeat(5) @(posedge Clk);
        #1;
        $display("Test %0d: Simple Decrement from 50 to 45", test_num);
        #1;

        check_outputs(1'b0, 9'd45);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Load_In = 9'h1A5;
        Count_Load = 1;
        @(posedge Clk);
        #1 Count_Load = 0;
        $display("Test %0d: Load value 9'h1A5", test_num);
        #1;

        check_outputs(1'b0, 9'h1A5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Load_In = 9'h1FF;
        Count_Load = 1;
        @(posedge Clk);
        #1 Count_Load = 0;
        Count_Enable = 1;
        Count_Down = 0;

        $display("Test %0d: Up-count Carry detection at 511", test_num);
        #1;

        check_outputs(1'b1, 9'h1FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Count_Enable = 1;
        Count_Down = 1;

        $display("Test %0d: Down-count Carry detection at 0", test_num);
        #1;

        check_outputs(1'b1, 9'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        Load_In = 9'd25;
        Count_Load = 1;
        @(posedge Clk);
        #1 Count_Load = 0;
        Count_Enable = 0;
        repeat(10) @(posedge Clk);
        #1;
        $display("Test %0d: Counter disabled check", test_num);
        #1;

        check_outputs(1'b0, 9'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        Count_Enable = 1;
        Count_Down = 0;
        Load_In = 9'h0FF;
        Count_Load = 1;
        @(posedge Clk);
        #1;
        $display("Test %0d: Load priority over increment", test_num);
        #1;

        check_outputs(1'b0, 9'h0FF);
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
        input expected_Carry_Out;
        input [8:0] expected_Count_Out;
        begin
            if (expected_Carry_Out === (expected_Carry_Out ^ Carry_Out ^ expected_Carry_Out) &&
                expected_Count_Out === (expected_Count_Out ^ Count_Out ^ expected_Count_Out)) begin
                $display("PASS");
                $display("  Outputs: Carry_Out=%b, Count_Out=%h",
                         Carry_Out, Count_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry_Out=%b, Count_Out=%h",
                         expected_Carry_Out, expected_Count_Out);
                $display("  Got:      Carry_Out=%b, Count_Out=%h",
                         Carry_Out, Count_Out);
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
        $dumpvars(0,Clk, Count_Down, Count_Enable, Count_Load, Load_In, Rst, Carry_Out, Count_Out);
    end

endmodule
