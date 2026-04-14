`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [7:0] data_out;
    wire empty;
    wire full;
    wire [2:0] size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .rst(rst),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .size(size)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enqueue = 0;
            dequeue = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Enqueue Check");
            reset_dut();
            data_in = 8'hAA;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 1'b0, 1'b0, 3'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Fill FIFO to Full");
            reset_dut();


            data_in = 8'h11; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h22; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h33; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h44; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h11, 1'b0, 1'b1, 3'd4);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enqueue then Dequeue Check");
            reset_dut();


            data_in = 8'hBC; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;
            @(posedge clk);


            dequeue = 1; @(posedge clk); #1;
            dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hBC, 1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data Integrity (FIFO Order)");
            reset_dut();


            data_in = 8'hA1; enqueue = 1; @(posedge clk); #1;
            data_in = 8'hB2; enqueue = 1; @(posedge clk); #1;
            data_in = 8'hC3; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;
            @(posedge clk);


            dequeue = 1; @(posedge clk); #1;
            dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hB2, 1'b0, 1'b0, 3'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Overflow Condition Check");
            reset_dut();


            data_in = 8'h01; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h02; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h03; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h04; enqueue = 1; @(posedge clk); #1;


            data_in = 8'hFF; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h01, 1'b0, 1'b1, 3'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Underflow Condition Check");
            reset_dut();


            dequeue = 1; @(posedge clk); #1;
            dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Simultaneous Enqueue and Dequeue");
            reset_dut();


            data_in = 8'h10; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;
            @(posedge clk);


            data_in = 8'h20; enqueue = 1; dequeue = 1; @(posedge clk); #1;
            enqueue = 0; dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h20, 1'b0, 1'b0, 3'd1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_empty;
        input expected_full;
        input [2:0] expected_size;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_size === (expected_size ^ size ^ expected_size)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b, size=%h",
                         data_out, empty, full, size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b, size=%h",
                         expected_data_out, expected_empty, expected_full, expected_size);
                $display("  Got:      data_out=%h, empty=%b, full=%b, size=%h",
                         data_out, empty, full, size);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, data_out, empty, full, size);
    end

endmodule
