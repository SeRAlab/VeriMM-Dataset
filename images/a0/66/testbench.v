`timescale 1ns/1ps

module Shift_Register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg shift;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Shift_Register_8bit dut (
        .D(D),
        .clk(clk),
        .load(load),
        .shift(shift),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 1;
            shift = 0;
            D = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();

            @(posedge clk);
            D = 8'hA5;
            load = 1;
            shift = 0;

            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Right Shift", test_num);
            reset_dut();


            @(posedge clk);
            D = 8'h80;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;


            #1;



            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Right Shifts", test_num);
            reset_dut();


            @(posedge clk);
            D = 8'h0F;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            shift = 1;
            repeat(4) @(posedge clk);
            #1;
            shift = 0;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Load should take priority)", test_num);
            reset_dut();


            @(posedge clk);
            D = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;


            D = 8'h55;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence", test_num);
            reset_dut();


            @(posedge clk);
            D = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;


            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Shift_Register_8bit Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, shift, Q);
    end

endmodule
