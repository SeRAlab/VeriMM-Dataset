`timescale 1ns/1ps

module PISO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    wire ready;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .ready(ready),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Load 8'hAA (10101010)");
            reset_dut();
            parallel_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(8) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Load 8'h55 (01010101)");
            reset_dut();
            parallel_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(8) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Load 8'hFF (11111111)");
            reset_dut();
            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(8) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Load 8'h00 (00000000)");
            reset_dut();
            parallel_in = 8'h00;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(8) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Load 8'hCC (11001100)");
            reset_dut();
            parallel_in = 8'hCC;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(8) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO Testbench");
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
        input expected_ready;
        input expected_serial_out;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, serial_out=%b",
                         ready, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, serial_out=%b",
                         expected_ready, expected_serial_out);
                $display("  Got:      ready=%b, serial_out=%b",
                         ready, serial_out);
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
        $dumpvars(0,clk, load, parallel_in, ready, serial_out);
    end

endmodule
