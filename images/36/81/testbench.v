`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    reg start;
    reg [3:0] transfer_size;
    wire [3:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .transfer_size(transfer_size),
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
            rst = 1;
            start = 0;
            data_in = 0;
            transfer_size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Transfer size 1...");
            reset_dut();
            test_num = 1;


            transfer_size = 4'd1;
            data_in = 4'hA;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);

            #1;


            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Transfer size 5...");
            reset_dut();
            test_num = 2;

            transfer_size = 4'd5;
            start = 1;
            data_in = 4'h1;
            @(posedge clk);
            #1 start = 0;


            data_in = 4'h2; @(posedge clk);
            #1 data_in = 4'h3; @(posedge clk);
            #1 data_in = 4'h4; @(posedge clk);
            #1 data_in = 4'h5;


            while (!done) @(posedge clk);

            #1;


            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Transfer size 15...");
            reset_dut();
            test_num = 3;

            transfer_size = 4'd15;
            start = 1;
            data_in = 4'h0;
            @(posedge clk);
            #1 start = 0;


            for (i = 1; i < 15; i = i + 1) begin
                data_in = i[3:0];
                @(posedge clk);
                #1;
            end


            while (!done) @(posedge clk);

            #1;


            check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Two units transfer...");
            reset_dut();
            test_num = 4;

            transfer_size = 4'd2;
            start = 1;
            data_in = 4'hF;
            @(posedge clk);
            #1 start = 0;
            data_in = 4'h3;

            while (!done) @(posedge clk);

            #1;


            check_outputs(4'h3, 1'b1);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, start, transfer_size, data_out, done);
    end

endmodule
