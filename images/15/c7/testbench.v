`timescale 1ns/1ps

module sipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg load;
    reg reset;
    wire [4:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sipo_shift_register dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .parallel_out(parallel_out)
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
            data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Shift in all 1s (11111)");
            reset_dut();
            load = 1;
            data = 1;

            repeat(5) @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Shift in pattern 10101");
            reset_dut();
            load = 1;

            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Verify load signal gating");
            reset_dut();


            load = 1;
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);


            load = 0;
            data = 0; @(posedge clk);
            data = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Shift more than 5 bits (Overflow)");
            reset_dut();
            load = 1;

            data = 1; repeat(5) @(posedge clk);
            data = 0; @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset during shifting");
            reset_dut();
            load = 1;
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            load = 0;
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sipo_shift_register Testbench");
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
        input [4:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, data, load, reset, parallel_out);
    end

endmodule
