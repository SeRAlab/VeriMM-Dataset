`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dequeue;
    reg enqueue;
    reg [7:0] enqueue_data;
    reg rst;
    wire [7:0] dequeue_data;
    wire empty;
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
        .enqueue_data(enqueue_data),
        .rst(rst),
        .dequeue_data(dequeue_data),
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
            enqueue_data = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(dequeue_data, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Enqueue", test_num);
            reset_dut();
            enqueue_data = 8'hAA;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;

            #1;


            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill to Full", test_num);
            reset_dut();
            enqueue = 1;
            for (i = 0; i < 8; i = i + 1) begin
                enqueue_data = i + 1;
                @(posedge clk);
            end
            #1 enqueue = 0;

            #1;


            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill then Empty", test_num);
            reset_dut();

            enqueue = 1;
            for (i = 0; i < 8; i = i + 1) begin
                enqueue_data = i + 1;
                @(posedge clk);
            end
            #1 enqueue = 0;

            dequeue = 1;
            repeat(8) @(posedge clk);
            #1 dequeue = 0;

            #1;


            check_outputs(dequeue_data, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Pointer Wrap-around", test_num);
            reset_dut();

            enqueue = 1;
            for (i = 0; i < 4; i = i + 1) begin
                enqueue_data = 8'hF0 + i;
                @(posedge clk);
            end
            #1 enqueue = 0;

            dequeue = 1;
            repeat(4) @(posedge clk);
            #1 dequeue = 0;

            enqueue = 1;
            for (i = 0; i < 8; i = i + 1) begin
                enqueue_data = i;
                @(posedge clk);
            end
            #1 enqueue = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Enqueue/Dequeue", test_num);
            reset_dut();

            enqueue_data = 8'h55;
            enqueue = 1;
            @(posedge clk);
            #1;

            enqueue_data = 8'h66;
            enqueue = 1;
            dequeue = 1;
            @(posedge clk);
            #1;
            enqueue = 0;
            dequeue = 0;

            #1;


            check_outputs(8'h66, 1'b0, 1'b0);
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
        input [7:0] expected_dequeue_data;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dequeue_data === (expected_dequeue_data ^ dequeue_data ^ expected_dequeue_data) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dequeue_data=%h, empty=%b, full=%b",
                         dequeue_data, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dequeue_data=%h, empty=%b, full=%b",
                         expected_dequeue_data, expected_empty, expected_full);
                $display("  Got:      dequeue_data=%h, empty=%b, full=%b",
                         dequeue_data, empty, full);
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
        $dumpvars(0,clk, dequeue, enqueue, enqueue_data, rst, dequeue_data, empty, full);
    end

endmodule
