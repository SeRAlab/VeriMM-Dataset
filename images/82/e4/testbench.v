`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    reg shift_en;
    reg shift_left;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift_en(shift_en),
        .shift_left(shift_left),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift_en = 0;
            shift_left = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Parallel Load (0xABCD)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift Left (Single bit)", test_num);
            reset_dut();

            load = 1;
            data_in = 16'h0001;
            @(posedge clk);
            #1 load = 0;

            shift_en = 1;
            shift_left = 1;
            @(posedge clk);
            #1 shift_en = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift Right (Single bit)", test_num);
            reset_dut();

            load = 1;
            data_in = 16'h8000;
            @(posedge clk);
            #1 load = 0;

            shift_en = 1;
            shift_left = 0;
            @(posedge clk);
            #1 shift_en = 0;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %03d: Multiple Shifts Left (4 bits)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'hF00F;
            @(posedge clk);
            #1 load = 0;
            shift_en = 1;
            shift_left = 1;
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1 shift_en = 0;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %03d: Multiple Shifts Right (4 bits)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'hF00F;
            @(posedge clk);
            #1 load = 0;
            shift_en = 1;
            shift_left = 0;
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1 shift_en = 0;

            #1;


            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Priority Check (Load over Shift)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'hAAAA;
            shift_en = 1;
            shift_left = 1;
            @(posedge clk);
            #1 load = 0; shift_en = 0;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift until empty (Zeros fill)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            #1 load = 0;
            shift_en = 1;
            shift_left = 1;
            repeat(16) @(posedge clk);
            #1 shift_en = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Priority Check (Reset over Load)", test_num);
            reset_dut();
            load = 1;
            data_in = 16'h5555;
            reset = 1;
            @(posedge clk);
            #1 reset = 0; load = 0;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift_en, shift_left, data_out);
    end

endmodule
