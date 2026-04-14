`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] Addr;
    reg [7:0] DIN;
    reg Enabled;
    reg LenCtr_Clock;
    reg [7:0] LenCtr_In;
    reg LinCtr_Clock;
    reg MW;
    reg ce;
    reg clk;
    reg reset;
    wire IsNonZero;
    wire [3:0] Sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .DIN(DIN),
        .Enabled(Enabled),
        .LenCtr_Clock(LenCtr_Clock),
        .LenCtr_In(LenCtr_In),
        .LinCtr_Clock(LinCtr_Clock),
        .MW(MW),
        .ce(ce),
        .clk(clk),
        .reset(reset),
        .IsNonZero(IsNonZero),
        .Sample(Sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        Addr = 0;
        DIN = 0;
        Enabled = 0;
        LenCtr_Clock = 0;
        LinCtr_Clock = 0;
        MW = 0;
        ce = 0;
        LenCtr_In = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task write_reg;

        input [1:0] r_addr;
        input [7:0] r_data;
        begin
            @(posedge clk);
            Addr = r_addr;
            DIN = r_data;
            MW = 1;
            ce = 1;
            @(posedge clk);
            MW = 0;
            ce = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        write_reg(2'h0, 8'hFF);
        write_reg(2'h2, 8'h01);
        write_reg(2'h3, 8'h00);

        Enabled = 1;
        ce = 1;


        repeat(20) @(posedge clk);



        #1;




        check_outputs(1'b1, Sample);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        write_reg(2'h0, 8'hFF);
        write_reg(2'h2, 8'h01);
        write_reg(2'h3, 8'h00);

        Enabled = 0;
        ce = 1;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase004;

    reg [3:0] sample_at_pause;
    begin
        test_num = 4;
        reset_dut();

        write_reg(2'h0, 8'hFF);
        write_reg(2'h2, 8'h04);
        write_reg(2'h3, 8'h00);
        Enabled = 1;
        ce = 1;

        repeat(10) @(posedge clk);
        sample_at_pause = Sample;

        ce = 0;
        repeat(20) @(posedge clk);


        #1;



        check_outputs(1'b1, sample_at_pause);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        write_reg(2'h0, 8'h01);
        write_reg(2'h2, 8'h01);
        write_reg(2'h3, 8'h00);
        Enabled = 1;
        ce = 1;


        repeat(5) begin
            LinCtr_Clock = 1;
            @(posedge clk);
            LinCtr_Clock = 0;
            repeat(2) @(posedge clk);
        end



        #1;




        check_outputs(1'b0, Sample);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        write_reg(2'h0, 8'hFF);
        write_reg(2'h2, 8'hFF);
        write_reg(2'h3, 8'h07);
        Enabled = 1;
        ce = 1;

        repeat(100) @(posedge clk);



        #1;




        check_outputs(1'b1, Sample);
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
        input expected_IsNonZero;
        input [3:0] expected_Sample;
        begin
            if (expected_IsNonZero === (expected_IsNonZero ^ IsNonZero ^ expected_IsNonZero) &&
                expected_Sample === (expected_Sample ^ Sample ^ expected_Sample)) begin
                $display("PASS");
                $display("  Outputs: IsNonZero=%b, Sample=%h",
                         IsNonZero, Sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IsNonZero=%b, Sample=%h",
                         expected_IsNonZero, expected_Sample);
                $display("  Got:      IsNonZero=%b, Sample=%h",
                         IsNonZero, Sample);
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
        $dumpvars(0,Addr, DIN, Enabled, LenCtr_Clock, LenCtr_In, LinCtr_Clock, MW, ce, clk, reset, IsNonZero, Sample);
    end

endmodule
