`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [3:0] count;
    wire [7:0] data_out;
    wire overflow;
    wire underflow;

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
        .count(count),
        .data_out(data_out),
        .overflow(overflow),
        .underflow(underflow)
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Enqueue and Dequeue", test_num);
            reset_dut();


            data_in = 8'hA5;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;
            @(posedge clk);
            #1;


            dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd0, 8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to 4 elements", test_num);
            reset_dut();

            for (i = 1; i <= 4; i = i + 1) begin
                data_in = i[7:0];
                enqueue = 1;
                @(posedge clk);
                #1;
            end
            enqueue = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd4, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Underflow Check", test_num);
            reset_dut();


            dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Overflow Check", test_num);
            reset_dut();


            enqueue = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end


            data_in = 8'hFF;
            @(posedge clk);
            #1 enqueue = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd8, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: FIFO Ordering Check", test_num);
            reset_dut();


            data_in = 8'h11; enqueue = 1; @(posedge clk); #1;
            data_in = 8'h22; enqueue = 1; @(posedge clk); #1;
            enqueue = 0; @(posedge clk); #1;


            dequeue = 1; @(posedge clk); #1;
            dequeue = 0; @(posedge clk); #1;


            #1;



            check_outputs(4'd1, 8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Enqueue and Dequeue", test_num);
            reset_dut();


            data_in = 8'hAA; enqueue = 1; @(posedge clk); #1;
            enqueue = 0; @(posedge clk); #1;


            data_in = 8'hBB;
            enqueue = 1;
            dequeue = 1;
            @(posedge clk);
            #1;
            enqueue = 0;
            dequeue = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd1, 8'hAA, 1'b0, 1'b0);
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
        input [3:0] expected_count;
        input [7:0] expected_data_out;
        input expected_overflow;
        input expected_underflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%h, overflow=%b, underflow=%b",
                         count, data_out, overflow, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%h, overflow=%b, underflow=%b",
                         expected_count, expected_data_out, expected_overflow, expected_underflow);
                $display("  Got:      count=%h, data_out=%h, overflow=%b, underflow=%b",
                         count, data_out, overflow, underflow);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, count, data_out, overflow, underflow);
    end

endmodule
