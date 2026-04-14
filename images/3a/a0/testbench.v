`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [2:0] current_size;
    wire [7:0] data_out;
    wire empty;
    wire full;

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
        .current_size(current_size),
        .data_out(data_out),
        .empty(empty),
        .full(full)
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Enqueue", test_num);
            reset_dut();
            enqueue = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            enqueue = 0;

            #1;


            check_outputs(3'd1, 8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill FIFO", test_num);
            reset_dut();
            enqueue = 1;
            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;
            data_in = 8'h33; @(posedge clk); #1;
            data_in = 8'h44; @(posedge clk); #1;
            enqueue = 0;

            #1;


            check_outputs(3'd4, 8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enqueue and Dequeue", test_num);
            reset_dut();

            enqueue = 1;
            data_in = 8'hA1; @(posedge clk); #1;
            data_in = 8'hA2; @(posedge clk); #1;
            enqueue = 0;

            dequeue = 1;
            @(posedge clk); #1;
            dequeue = 0;

            #1;


            check_outputs(3'd1, 8'hA2, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Handling", test_num);
            reset_dut();
            enqueue = 1;
            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;
            data_in = 8'h04; @(posedge clk); #1;
            data_in = 8'h05; @(posedge clk); #1;
            enqueue = 0;

            #1;


            check_outputs(3'd4, 8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Underflow Handling", test_num);
            reset_dut();
            dequeue = 1;
            @(posedge clk); #1;
            dequeue = 0;

            #1;


            check_outputs(3'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Circular Wrap-around", test_num);
            reset_dut();

            enqueue = 1;
            data_in = 8'h10; @(posedge clk); #1;
            data_in = 8'h20; @(posedge clk); #1;
            data_in = 8'h30; @(posedge clk); #1;
            enqueue = 0;

            dequeue = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            dequeue = 0;

            enqueue = 1;
            data_in = 8'h40; @(posedge clk); #1;
            data_in = 8'h50; @(posedge clk); #1;
            enqueue = 0;

            #1;


            check_outputs(3'd3, 8'h30, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Enq/Deq", test_num);
            reset_dut();

            enqueue = 1; data_in = 8'hBB; @(posedge clk); #1;
            enqueue = 0;

            enqueue = 1; data_in = 8'hCC;
            dequeue = 1;
            @(posedge clk); #1;
            enqueue = 0;
            dequeue = 0;

            #1;


            check_outputs(3'd1, 8'hCC, 1'b0, 1'b0);
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
        input [2:0] expected_current_size;
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_current_size === (expected_current_size ^ current_size ^ expected_current_size) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: current_size=%h, data_out=%h, empty=%b, full=%b",
                         current_size, data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_size=%h, data_out=%h, empty=%b, full=%b",
                         expected_current_size, expected_data_out, expected_empty, expected_full);
                $display("  Got:      current_size=%h, data_out=%h, empty=%b, full=%b",
                         current_size, data_out, empty, full);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, current_size, data_out, empty, full);
    end

endmodule
