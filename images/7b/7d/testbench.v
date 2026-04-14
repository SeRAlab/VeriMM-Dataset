`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] i_datain;
    reg i_datain_valid;
    reg [1:0] i_dataout_stall;
    reg resetn;
    wire o_datain_stall;
    wire [31:0] o_dataout;
    wire [1:0] o_dataout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .i_datain(i_datain),
        .i_datain_valid(i_datain_valid),
        .i_dataout_stall(i_dataout_stall),
        .resetn(resetn),
        .o_datain_stall(o_datain_stall),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            i_datain = 32'h0;
            i_datain_valid = 0;
            i_dataout_stall = 2'b00;
            @(posedge clock);
            #1;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            i_datain = 32'hAAAA_BBB0;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 32'hAAAA_BBB0, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_datain = 32'hCCCC_DDD1;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 32'hCCCC_DDD1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            i_datain = 32'h1111_2220;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b01;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 32'h1111_2220, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            i_datain = 32'h3333_4441;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 32'h3333_4441, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            i_datain = 32'h5555_6660;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 32'h5555_6660, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            i_datain = 32'hFFFF_FFFF;
            i_datain_valid = 1'b0;
            i_dataout_stall = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 32'hFFFF_FFFF, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0000_0000, 2'b00);
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
        input expected_o_datain_stall;
        input [31:0] expected_o_dataout;
        input [1:0] expected_o_dataout_valid;
        begin
            if (expected_o_datain_stall === (expected_o_datain_stall ^ o_datain_stall ^ expected_o_datain_stall) &&
                expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
                         o_datain_stall, o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
                         expected_o_datain_stall, expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
                         o_datain_stall, o_dataout, o_dataout_valid);
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
        $dumpvars(0,clock, i_datain, i_datain_valid, i_dataout_stall, resetn, o_datain_stall, o_dataout, o_dataout_valid);
    end

endmodule
