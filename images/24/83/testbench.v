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
        data_in = 8'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking reset state", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single write and read", test_num);
        reset_dut();


        data_in = 8'hA5;
        enqueue = 1;
        @(posedge clk);
        enqueue = 0;


        @(posedge clk);
        dequeue = 1;
        @(posedge clk);
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'hA5, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %03d: Filling FIFO to full", test_num);
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            data_in = i + 8'h10;
            enqueue = 1;
            @(posedge clk);
        end
        enqueue = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: FIFO ordering check (2 items)", test_num);
        reset_dut();


        data_in = 8'h11; enqueue = 1;
        @(posedge clk);

        data_in = 8'h22; enqueue = 1;
        @(posedge clk);
        enqueue = 0;


        dequeue = 1;
        @(posedge clk);
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h11, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %03d: Overflow protection check", test_num);
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            data_in = i; enqueue = 1;
            @(posedge clk);
        end


        data_in = 8'hFF;
        enqueue = 1;
        @(posedge clk);
        enqueue = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Underflow protection check", test_num);
        reset_dut();


        dequeue = 1;
        @(posedge clk);
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Simultaneous enqueue and dequeue", test_num);
        reset_dut();


        data_in = 8'h55; enqueue = 1;
        @(posedge clk);
        enqueue = 0;


        data_in = 8'h66; enqueue = 1; dequeue = 1;
        @(posedge clk);
        enqueue = 0; dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h55, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, data_out, empty, full);
    end

endmodule
