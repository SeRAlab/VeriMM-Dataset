`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_address;
    reg [3:0] num_words;
    reg rst;
    reg [7:0] src_address;
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
        .data_in(data_in),
        .dest_address(dest_address),
        .num_words(num_words),
        .rst(rst),
        .src_address(src_address),
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
            rst = 1;
            start = 0;
            data_in = 0;
            src_address = 0;
            dest_address = 0;
            num_words = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Single Word Transfer");
            reset_dut();

            src_address = 8'h10;
            dest_address = 8'h20;
            num_words = 4'd1;
            data_in = 8'hA5;
            start = 1;

            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase 002: Multi-word Transfer (5 words)");
            reset_dut();

            src_address = 8'h00;
            dest_address = 8'h80;
            num_words = 4'd5;
            start = 1;


            for (i = 1; i <= 5; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                start = 0;
            end


            while (!done) @(posedge clk);


            #1;



            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Maximum Length Transfer (15 words)");
            reset_dut();

            src_address = 8'h00;
            dest_address = 8'hFF;
            num_words = 4'd15;
            start = 1;

            for (i = 0; i < 15; i = i + 1) begin
                data_in = 8'hF0 + i[7:0];
                @(posedge clk);
                start = 0;
            end

            while (!done) @(posedge clk);


            #1;



            check_outputs(8'hFE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Consecutive Transfers");
            reset_dut();


            src_address = 8'h01;
            dest_address = 8'h02;
            num_words = 4'd1;
            data_in = 8'h11;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            src_address = 8'hAA;
            dest_address = 8'hBB;
            num_words = 4'd1;
            data_in = 8'h22;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset during operation");
            reset_dut();

            num_words = 4'd10;
            start = 1;
            data_in = 8'hCC;
            @(posedge clk);
            start = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            #1;


            #1;



            check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,clk, data_in, dest_address, num_words, rst, src_address, start, data_out, done);
    end

endmodule
