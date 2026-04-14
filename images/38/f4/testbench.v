`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg [3:0] num_transfers;
    reg reset;
    reg [7:0] src_addr;
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
        .dest_addr(dest_addr),
        .num_transfers(num_transfers),
        .reset(reset),
        .src_addr(src_addr),
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
            reset = 1;
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            data_in = 0;
            num_transfers = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Single Data Transfer", test_num);
            reset_dut();


            src_addr = 8'h10;
            dest_addr = 8'h20;
            num_transfers = 4'd1;
            data_in = 8'hAA;


            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);



            #1;




            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTest Case %0d: Multiple Data Transfers (4)", test_num);
            reset_dut();

            src_addr = 8'h05;
            dest_addr = 8'h80;
            num_transfers = 4'd4;

            @(posedge clk);
            #1 start = 1;


            for (i = 0; i < 4; i = i + 1) begin
                #1 data_in = 8'h10 + i;
                @(posedge clk);
                #1 start = 0;
            end


            while (!done) @(posedge clk);


            #1;



            check_outputs(8'h13, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTest Case %0d: Maximum Transfers (15)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'hFF;
            num_transfers = 4'd15;

            @(posedge clk);
            #1 start = 1;

            for (i = 0; i < 15; i = i + 1) begin
                #1 data_in = i[7:0];
                @(posedge clk);
                #1 start = 0;
            end

            while (!done) @(posedge clk);


            #1;



            check_outputs(8'd14, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Zero Transfer Request", test_num);
            reset_dut();

            num_transfers = 4'd0;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (2) @(posedge clk);




            #1;





            check_outputs(8'h00, done);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Consecutive Transfers", test_num);
            reset_dut();


            num_transfers = 4'd2;
            @(posedge clk);
            #1 start = 1;
            data_in = 8'hA1; @(posedge clk);
            #1 start = 0; data_in = 8'hA2; @(posedge clk);
            while(!done) @(posedge clk);


            #1 start = 1;
            num_transfers = 4'd1;
            data_in = 8'hB1;
            @(posedge clk);
            #1 start = 0;
            while(!done) @(posedge clk);

            #1;


            check_outputs(8'hB1, 1'b1);
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
        $dumpvars(0,clk, data_in, dest_addr, num_transfers, reset, src_addr, start, data_out, done);
    end

endmodule
