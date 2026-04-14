`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    reg [3:0] transfer_length;
    wire [7:0] current_dest_addr;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .transfer_length(transfer_length),
        .current_dest_addr(current_dest_addr),
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
            src_addr = 8'h00;
            dest_addr = 8'h00;
            transfer_length = 4'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Transfer (Len=4)", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            transfer_length = 4'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;



            repeat (10) begin
                if (done) break;
                @(posedge clk);
            end





            #1;






            check_outputs(8'h23, 8'h13, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Transfer (Len=1)", test_num);
            reset_dut();

            src_addr = 8'hA0;
            dest_addr = 8'hB0;
            transfer_length = 4'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (5) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'hB0, 8'hA0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Transfer (Len=15)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'h40;
            transfer_length = 4'd15;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h4E, 8'h0E, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            transfer_length = 4'd5;
            start = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(current_dest_addr, data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Transfer", test_num);
            reset_dut();


            src_addr = 8'h05;
            dest_addr = 8'h50;
            transfer_length = 4'd2;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while(!done) @(posedge clk);


            @(posedge clk);
            src_addr = 8'h80;
            dest_addr = 8'h90;
            transfer_length = 4'd3;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h92, 8'h82, 1'b1);
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
        input [7:0] expected_current_dest_addr;
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_current_dest_addr === (expected_current_dest_addr ^ current_dest_addr ^ expected_current_dest_addr) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_dest_addr=%h, data_out=%h, done=%b",
                         current_dest_addr, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_dest_addr=%h, data_out=%h, done=%b",
                         expected_current_dest_addr, expected_data_out, expected_done);
                $display("  Got:      current_dest_addr=%h, data_out=%h, done=%b",
                         current_dest_addr, data_out, done);
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
        $dumpvars(0,clk, dest_addr, reset, src_addr, start, transfer_length, current_dest_addr, data_out, done);
    end

endmodule
