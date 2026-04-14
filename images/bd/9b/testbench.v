`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Add_dec;
    reg Load_regs;
    reg clock;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg reset;
    wire [15:0] PR;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Add_dec(Add_dec),
        .Load_regs(Load_regs),
        .clock(clock),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .reset(reset),
        .PR(PR),
        .Zero(Zero)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            Add_dec = 0;
            Load_regs = 0;
            multiplicand = 0;
            multiplier = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("Testcase %0d: 7 * 6", test_num);
            reset_dut();
            multiplicand = 8'd7;
            multiplier = 8'd6;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;


            for (i = 0; i < 6; i = i + 1) begin
                Add_dec = 1;
                @(posedge clock);
                #1;
            end
            Add_dec = 0;
            #1;

            check_outputs(16'd42, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 12 * 0", test_num);
            reset_dut();
            multiplicand = 8'd12;
            multiplier = 8'd0;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;


            #1;



            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: 0 * 25", test_num);
            reset_dut();
            multiplicand = 8'd0;
            multiplier = 8'd25;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            for (i = 0; i < 25; i = i + 1) begin
                Add_dec = 1;
                @(posedge clock);
                #1;
            end
            Add_dec = 0;
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 255 * 1", test_num);
            reset_dut();
            multiplicand = 8'd255;
            multiplier = 8'd1;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Add_dec = 1;
            @(posedge clock);
            #1 Add_dec = 0;

            #1;


            check_outputs(16'd255, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 255 * 2", test_num);
            reset_dut();
            multiplicand = 8'd255;
            multiplier = 8'd2;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Add_dec = 1;
            @(posedge clock);
            @(posedge clock);
            #1 Add_dec = 0;

            #1;


            check_outputs(16'd510, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: 255 * 255", test_num);
            reset_dut();
            multiplicand = 8'd255;
            multiplier = 8'd255;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            for (i = 0; i < 255; i = i + 1) begin
                Add_dec = 1;
                @(posedge clock);
                #1;
            end
            Add_dec = 0;
            #1;

            check_outputs(16'd65025, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: 15 * 15", test_num);
            reset_dut();
            multiplicand = 8'd15;
            multiplier = 8'd15;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            for (i = 0; i < 15; i = i + 1) begin
                Add_dec = 1;
                @(posedge clock);
                #1;
            end
            Add_dec = 0;
            #1;

            check_outputs(16'd225, 1'b1);
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
        input [15:0] expected_PR;
        input expected_Zero;
        begin
            if (expected_PR === (expected_PR ^ PR ^ expected_PR) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: PR=%h, Zero=%b",
                         PR, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PR=%h, Zero=%b",
                         expected_PR, expected_Zero);
                $display("  Got:      PR=%h, Zero=%b",
                         PR, Zero);
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
        $dumpvars(0,Add_dec, Load_regs, clock, multiplicand, multiplier, reset, PR, Zero);
    end

endmodule
