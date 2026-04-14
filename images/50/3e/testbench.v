`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] parallel_in;
    reg rst_n;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            parallel_in = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Testing Parallel Load");
            reset_dut();
            parallel_in = 4'b1010;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Testing Single Left Shift");
            reset_dut();

            parallel_in = 4'b1011;
            load = 1;
            @(negedge clk);

            load = 0;
            @(negedge clk);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Testing Multiple Left Shifts");
            reset_dut();

            parallel_in = 4'b0001;
            load = 1;
            @(negedge clk);
            load = 0;

            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Testing Shift-out to Zero");
            reset_dut();
            parallel_in = 4'b1111;
            load = 1;
            @(negedge clk);
            load = 0;

            repeat(4) @(negedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Testing Load Priority");
            reset_dut();
            parallel_in = 4'b0101;
            load = 1;
            @(negedge clk);

            parallel_in = 4'b1110;
            load = 1;
            @(negedge clk);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, load, parallel_in, rst_n, shift_out);
    end

endmodule
