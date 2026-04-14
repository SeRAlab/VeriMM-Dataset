`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [3:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
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
            reset = 1;
            serial_in = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Shifting in sequence 1, 0, 1, 1", test_num);
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b1101, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shifting in sequence 0, 1, 1, 0", test_num);
            reset_dut();
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Shifting in all ones", test_num);
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shifting in all zeros", test_num);
            reset_dut();
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Shifting in sequence 1, 0, 1, 0", test_num);
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) reset = 1;
            @(negedge clk) reset = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("siso_shift_register Testbench");
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
        input [3:0] expected_parallel_out;
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
        $dumpvars(0,clk, reset, serial_in, parallel_out, serial_out);
    end

endmodule
