`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Data_in;
    reg clock;
    reg reset;
    wire [16:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_in(Data_in),
        .clock(clock),
        .reset(reset),
        .Data_out(Data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            Data_in = 8'h0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Post-Reset Zero State Check", test_num);
            reset_dut();

            #1;


            check_outputs(17'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Stream Processing", test_num);
            reset_dut();
            Data_in = 8'd0;
            repeat(10) @(posedge clock);

            #1;


            check_outputs(17'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DC Step Response (Data_in = 10)", test_num);
            reset_dut();
            Data_in = 8'd10;

            repeat(8) @(posedge clock);

            #1;


            check_outputs(17'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Scale Step Response (Data_in = 255)", test_num);
            reset_dut();
            Data_in = 8'd255;

            repeat(8) @(posedge clock);

            #1;


            check_outputs(17'd1020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse Recovery Check", test_num);
            reset_dut();

            Data_in = 8'd100;
            @(posedge clock);

            Data_in = 8'd0;
            repeat(10) @(posedge clock);

            #1;


            check_outputs(17'd0);
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
        input [16:0] expected_Data_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
        $dumpvars(0,Data_in, clock, reset, Data_out);
    end

endmodule
