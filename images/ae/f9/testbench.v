`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg [1:0] shift_direction;
    reg slowena;
    wire [11:0] output_sum;

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
        .shift_direction(shift_direction),
        .slowena(slowena),
        .output_sum(output_sum)
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
            slowena = 0;
            data_in = 8'h00;
            shift_direction = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Data 8'hA5", test_num);
            reset_dut();
            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(12'hA50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Left (8'h55 -> 8'hAA)", test_num);
            reset_dut();
            data_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_direction = 2'b01;
            @(posedge clk);
            #1;
            shift_direction = 2'b00;

            #1;


            check_outputs(12'hAA0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Right (8'hAA -> 8'h55)", test_num);
            reset_dut();
            data_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_direction = 2'b10;
            @(posedge clk);
            #1;
            shift_direction = 2'b00;

            #1;


            check_outputs(12'h550);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Johnson Counter Step 1", test_num);
            reset_dut();
            slowena = 1;
            @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(12'h008);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Johnson Counter Step 4 (Sequence: 0-8-C-E-F)", test_num);
            reset_dut();
            slowena = 1;
            repeat(4) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(12'h00F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Simultaneous Shift and Count", test_num);
            reset_dut();

            data_in = 8'h0F;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_direction = 2'b01;
            slowena = 1;
            @(posedge clk);
            #1;
            slowena = 0;
            shift_direction = 0;

            #1;


            check_outputs(12'h1E8);
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
        input [11:0] expected_output_sum;
        begin
            if (expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum)) begin
                $display("PASS");
                $display("  Outputs: output_sum=%h",
                         output_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sum=%h",
                         expected_output_sum);
                $display("  Got:      output_sum=%h",
                         output_sum);
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
        $dumpvars(0,clk, data_in, load, reset, shift_direction, slowena, output_sum);
    end

endmodule
