`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    reg shift;
    wire [7:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .shift(shift),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Task: Resetting DUT...");
            reset = 1;
            load = 0;
            shift = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();

            parallel_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Shift (Load 0x55 -> Shift)", test_num);
            reset_dut();


            parallel_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            shift = 1;
            @(posedge clk);
            #1 shift = 0;



            #1;




            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Shifts (Shift out 0x80)", test_num);
            reset_dut();


            parallel_in = 8'h80;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            shift = 1;
            @(posedge clk);
            #1 shift = 0;



            #1;




            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority (Load and Shift both high)", test_num);
            reset_dut();


            parallel_in = 8'hCC;
            load = 1;
            @(posedge clk);




            parallel_in = 8'h33;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;

            #1;


            check_outputs(8'h33, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State (No Load, No Shift)", test_num);
            reset_dut();


            parallel_in = 8'hEE;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(8'hEE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
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
        input [7:0] expected_parallel_out;
        input expected_serial_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, serial_out=%b",
                         expected_parallel_out, expected_serial_out);
                $display("  Got:      parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
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
        $dumpvars(0,clk, load, parallel_in, reset, shift, parallel_out, serial_out);
    end

endmodule
