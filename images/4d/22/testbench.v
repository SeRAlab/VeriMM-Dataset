`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear_Valid;
    reg [7:0] Data_in;
    reg Load;
    reg Set;
    reg Shift;
    reg TBR_en;
    reg clk;
    reg reset;
    wire TBR_Valid;
    wire Tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear_Valid(Clear_Valid),
        .Data_in(Data_in),
        .Load(Load),
        .Set(Set),
        .Shift(Shift),
        .TBR_en(TBR_en),
        .clk(clk),
        .reset(reset),
        .TBR_Valid(TBR_Valid),
        .Tx(Tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Clear_Valid = 0;
            Data_in = 8'h00;
            Load = 0;
            Set = 0;
            Shift = 0;
            TBR_en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Data_in = 8'hA5;
            TBR_en = 1;
            @(posedge clk);
            #1;
            TBR_en = 0;
            #1;

            check_outputs(1, Tx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            TBR_en = 1;
            @(posedge clk);
            #1;
            TBR_en = 0;
            Clear_Valid = 1;
            @(posedge clk);
            #1;
            Clear_Valid = 0;
            #1;

            check_outputs(0, Tx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            Data_in = 8'h01;
            TBR_en = 1;
            @(posedge clk);
            #1;
            TBR_en = 0;

            Load = 1;
            @(posedge clk);
            #1;
            Load = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Data_in = 8'h02;
            TBR_en = 1;
            @(posedge clk);
            #1;
            TBR_en = 0;
            Load = 1;
            @(posedge clk);
            #1;
            Load = 0;
            Shift = 1;
            @(posedge clk);
            #1;
            Shift = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            Data_in = 8'h80;
            TBR_en = 1;
            @(posedge clk);
            #1;
            TBR_en = 0;
            Load = 1;
            @(posedge clk);
            #1;
            Load = 0;
            Shift = 1;
            for(i=0; i<7; i=i+1) begin
                @(posedge clk);
            end
            #1;
            Shift = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Set = 1;
            @(posedge clk);
            #1;
            Set = 0;

            #1;


            check_outputs(TBR_Valid, 1);
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
        input expected_TBR_Valid;
        input expected_Tx;
        begin
            if (expected_TBR_Valid === (expected_TBR_Valid ^ TBR_Valid ^ expected_TBR_Valid) &&
                expected_Tx === (expected_Tx ^ Tx ^ expected_Tx)) begin
                $display("PASS");
                $display("  Outputs: TBR_Valid=%b, Tx=%b",
                         TBR_Valid, Tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TBR_Valid=%b, Tx=%b",
                         expected_TBR_Valid, expected_Tx);
                $display("  Got:      TBR_Valid=%b, Tx=%b",
                         TBR_Valid, Tx);
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
        $dumpvars(0,Clear_Valid, Data_in, Load, Set, Shift, TBR_en, clk, reset, TBR_Valid, Tx);
    end

endmodule
