`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [7:0] parallel_in;
    reg rst;
    reg start;
    wire busy;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .en(en),
        .parallel_in(parallel_in),
        .rst(rst),
        .start(start),
        .busy(busy),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            start = 0;
            parallel_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            parallel_in = 8'hA5;
            en = 1;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(WIDTH) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            parallel_in = 8'h00;
            en = 1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(WIDTH) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            parallel_in = 8'hFF;
            en = 1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(WIDTH) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            parallel_in = 8'hAA;
            en = 1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(4) @(posedge clk);
            #1 en = 0;
            repeat(5) @(posedge clk);

            if (busy !== 1'b1) $display("Error: Busy dropped while en was low");
            #1 en = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            parallel_in = 8'hFF;
            en = 1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(4) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial Testbench");
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
        input expected_busy;
        input expected_serial_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, serial_out=%b",
                         busy, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, serial_out=%b",
                         expected_busy, expected_serial_out);
                $display("  Got:      busy=%b, serial_out=%b",
                         busy, serial_out);
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
        $dumpvars(0,clk, en, parallel_in, rst, start, busy, serial_out);
    end

endmodule
