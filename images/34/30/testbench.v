`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .serial_in(serial_in),
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
            enable = 0;
            serial_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("Test Case 001: Shifting in all 1s...");
            reset_dut();
            enable = 1;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 1;
                @(posedge clk);
            end
            enable = 0;
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        reg [7:0] pattern;
        integer i;
        begin
            $display("Test Case 002: Shifting in pattern 10110011...");
            reset_dut();
            pattern = 8'b10110011;
            enable = 1;



            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            enable = 0;
            #1 #1;
 check_outputs(8'b10110011);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Testing enable signal (pausing shift)...");
            reset_dut();

            enable = 1;
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);

            enable = 0;
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);

            enable = 1;
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);

            enable = 0;
            #1 #1;
 check_outputs(8'h0B);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Overflow check (shifting 12 bits)...");
            reset_dut();
            enable = 1;

            serial_in = 1; repeat(4) @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);

            enable = 0;

            #1 #1;
 check_outputs(8'b01010101);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Test Case 005: Alternating bit pattern 10101010...");
            reset_dut();
            enable = 1;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = (i % 2 == 0) ? 1 : 0;
                @(posedge clk);
            end
            enable = 0;

            #1 #1;
 check_outputs(8'b10101010);
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
        input [7:0] expected_parallel_out;
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
        $dumpvars(0,clk, enable, reset, serial_in, parallel_out);
    end

endmodule
