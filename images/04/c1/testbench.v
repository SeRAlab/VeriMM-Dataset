`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dequeue;
    reg [7:0] enqueue;
    reg reset;
    wire empty;
    wire [7:0] front;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .reset(reset),
        .empty(empty),
        .front(front),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enqueue = 8'h0;
            dequeue = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking initial state after reset...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enqueueing one item...");
            test_num = 2;
            reset_dut();
            enqueue = 8'hAA;
            @(posedge clk);
            #1 enqueue = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hAA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Filling FIFO to depth 4...");
            test_num = 3;
            reset_dut();
            enqueue = 8'h11; @(posedge clk); #1;
            enqueue = 8'h22; @(posedge clk); #1;
            enqueue = 8'h33; @(posedge clk); #1;
            enqueue = 8'h44; @(posedge clk); #1;
            enqueue = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enqueueing 2 items and Dequeueing 1...");
            test_num = 4;
            reset_dut();
            enqueue = 8'hA1; @(posedge clk); #1;
            enqueue = 8'hB2; @(posedge clk); #1;
            enqueue = 8'h00;
            dequeue = 1'b1;  @(posedge clk); #1;
            dequeue = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hB2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Filling then emptying the FIFO...");
            test_num = 5;
            reset_dut();

            enqueue = 8'h01; @(posedge clk); #1;
            enqueue = 8'h02; @(posedge clk); #1;
            enqueue = 8'h03; @(posedge clk); #1;
            enqueue = 8'h04; @(posedge clk); #1;
            enqueue = 8'h00;

            repeat(4) begin
                dequeue = 1'b1; @(posedge clk); #1;
            end
            dequeue = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing pointer wrap-around...");
            test_num = 6;
            reset_dut();

            enqueue = 8'hD1; @(posedge clk); #1;
            enqueue = 8'hD2; @(posedge clk); #1;
            enqueue = 8'hD3; @(posedge clk); #1;
            enqueue = 8'h00;

            dequeue = 1'b1; @(posedge clk); #1;
            dequeue = 1'b1; @(posedge clk); #1;
            dequeue = 1'b0;

            enqueue = 8'hE4; @(posedge clk); #1;
            enqueue = 8'hE5; @(posedge clk); #1;
            enqueue = 8'hE6; @(posedge clk); #1;
            enqueue = 8'h00;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'hD3, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_empty;
        input [7:0] expected_front;
        input expected_full;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_front === (expected_front ^ front ^ expected_front) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, front=%h, full=%b",
                         empty, front, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, front=%h, full=%b",
                         expected_empty, expected_front, expected_full);
                $display("  Got:      empty=%b, front=%h, full=%b",
                         empty, front, full);
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
        $dumpvars(0,clk, dequeue, enqueue, reset, empty, front, full);
    end

endmodule
