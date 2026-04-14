`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] count;
    reg start;
    wire [7:0] data_out;
    wire [7:0] dest_address;
    wire done;
    wire [7:0] src_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .count(count),
        .start(start),
        .data_out(data_out),
        .dest_address(dest_address),
        .done(done),
        .src_address(src_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            count = 4'd0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single transfer (count = 1)", test_num);
            reset_dut();

            count = 4'd1;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 8'h01, 1'b1, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Medium transfer (count = 5)", test_num);
            reset_dut();

            count = 4'd5;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 8'h05, 1'b1, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum transfer (count = 15)", test_num);
            reset_dut();

            count = 4'd15;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 8'h0F, 1'b1, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sequential transfers (Back-to-back)", test_num);


            reset_dut();
            count = 4'd2;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);


            reset_dut();
            count = 4'd3;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 8'h03, 1'b1, 8'h03);
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
        input [7:0] expected_data_out;
        input [7:0] expected_dest_address;
        input expected_done;
        input [7:0] expected_src_address;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_dest_address === (expected_dest_address ^ dest_address ^ expected_dest_address) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_src_address === (expected_src_address ^ src_address ^ expected_src_address)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, dest_address=%h, done=%b, src_address=%h",
                         data_out, dest_address, done, src_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, dest_address=%h, done=%b, src_address=%h",
                         expected_data_out, expected_dest_address, expected_done, expected_src_address);
                $display("  Got:      data_out=%h, dest_address=%h, done=%b, src_address=%h",
                         data_out, dest_address, done, src_address);
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
        $dumpvars(0,clk, count, start, data_out, dest_address, done, src_address);
    end

endmodule
