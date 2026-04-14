`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num_bytes;
    reg rst_n;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .num_bytes(num_bytes),
        .rst_n(rst_n),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start = 0;
            num_bytes = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 1-byte transfer");
            test_num = 1;
            reset_dut();

            num_bytes = 8'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);



            #1;




            check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 5-byte transfer");
            test_num = 2;
            reset_dut();

            num_bytes = 8'd5;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);

            #1;


            check_outputs(8'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 16-byte transfer");
            test_num = 3;
            reset_dut();

            num_bytes = 8'd16;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'd16, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 255-byte transfer");
            test_num = 4;
            reset_dut();

            num_bytes = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: 0-byte transfer edge case");
            test_num = 5;
            reset_dut();

            num_bytes = 8'd0;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, num_bytes, rst_n, start, data_out, done);
    end

endmodule
