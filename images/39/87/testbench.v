`timescale 1ns/1ps

module I2C_Master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire ack_out;
    wire scl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Master dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .ack_out(ack_out),
        .scl(scl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Transmit 8'h55 (Alternating 01010101)", test_num);
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (1000) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Transmit 8'hAA (Alternating 10101010)", test_num);
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (1000) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Transmit 8'h00 (All Zeros)", test_num);
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (1000) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Transmit 8'hFF (All Ones)", test_num);
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (1000) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Transmit 8'hA5 (Mixed Pattern)", test_num);
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (1000) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Master Testbench");
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
        input expected_ack_out;
        input expected_scl;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, scl=%b",
                         ack_out, scl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, scl=%b",
                         expected_ack_out, expected_scl);
                $display("  Got:      ack_out=%b, scl=%b",
                         ack_out, scl);
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
        $dumpvars(0,clk, data_in, start, ack_out, scl);
    end

endmodule
