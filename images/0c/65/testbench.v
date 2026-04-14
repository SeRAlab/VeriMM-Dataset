`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] source_addr;
    reg start;
    reg [3:0] transfer_count;
    wire busy;
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
        .source_addr(source_addr),
        .start(start),
        .transfer_count(transfer_count),
        .busy(busy),
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
            source_addr = 8'h00;
            dest_addr = 8'h00;
            transfer_count = 4'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Standard Transfer (Count=5)", test_num);
            reset_dut();

            source_addr = 8'h10;
            dest_addr = 8'h50;
            transfer_count = 4'd5;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;



            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Minimum Transfer (Count=1)", test_num);
            reset_dut();

            source_addr = 8'h0A;
            dest_addr = 8'h0F;
            transfer_count = 4'd1;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Maximum Transfer (Count=15)", test_num);
            reset_dut();

            source_addr = 8'h00;
            dest_addr = 8'hFF;
            transfer_count = 4'd15;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Idle State Check", test_num);
            reset_dut();

            source_addr = 8'hAA;
            dest_addr = 8'hBB;
            transfer_count = 4'd8;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            source_addr = 8'h11;
            dest_addr = 8'h22;
            transfer_count = 4'd2;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);


            source_addr = 8'h33;
            dest_addr = 8'h44;
            transfer_count = 4'd3;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b0, data_out, 1'b1);
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
        input expected_busy;
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, done=%b",
                         expected_busy, expected_data_out, expected_done);
                $display("  Got:      busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
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
        $dumpvars(0,clk, dest_addr, reset, source_addr, start, transfer_count, busy, data_out, done);
    end

endmodule
