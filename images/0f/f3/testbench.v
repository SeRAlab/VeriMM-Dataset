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
        data_in = 8'h00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        $display("Reset completed.");
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Initial state after reset");
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Enqueue single element");
        reset_dut();
        data_in = 8'hAA;
        enqueue = 1;
        @(posedge clk);
        enqueue = 0;
        @(posedge clk);

        #1;


        check_outputs(8'hAA, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Fill FIFO to capacity");
        reset_dut();

        enqueue = 1; data_in = 8'h11; @(posedge clk);
        enqueue = 1; data_in = 8'h22; @(posedge clk);
        enqueue = 1; data_in = 8'h33; @(posedge clk);
        enqueue = 1; data_in = 8'h44; @(posedge clk);
        enqueue = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h11, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Fill then Empty");
        reset_dut();


        enqueue = 1; data_in = 8'h01; @(posedge clk);
        enqueue = 1; data_in = 8'h02; @(posedge clk);
        enqueue = 1; data_in = 8'h03; @(posedge clk);
        enqueue = 1; data_in = 8'h04; @(posedge clk);
        enqueue = 0;


        dequeue = 1; @(posedge clk);
        dequeue = 1; @(posedge clk);
        dequeue = 1; @(posedge clk);
        dequeue = 1; @(posedge clk);
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Verify FIFO sequence logic");
        reset_dut();

        enqueue = 1; data_in = 8'hA1; @(posedge clk);
        enqueue = 1; data_in = 8'hB2; @(posedge clk);
        enqueue = 0;

        dequeue = 1; @(posedge clk);
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'hB2, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: Overflow protection (writing 5 items into 4 slots)");
        reset_dut();

        enqueue = 1; data_in = 8'h01; @(posedge clk);
        enqueue = 1; data_in = 8'h02; @(posedge clk);
        enqueue = 1; data_in = 8'h03; @(posedge clk);
        enqueue = 1; data_in = 8'h04; @(posedge clk);
        enqueue = 1; data_in = 8'h05; @(posedge clk);
        enqueue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h01, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("testcase007: Simultaneous enqueue and dequeue on full FIFO");
        reset_dut();


        enqueue = 1; data_in = 8'h10; @(posedge clk);
        enqueue = 1; data_in = 8'h20; @(posedge clk);
        enqueue = 1; data_in = 8'h30; @(posedge clk);
        enqueue = 1; data_in = 8'h40; @(posedge clk);


        enqueue = 1; data_in = 8'h50;
        dequeue = 1;
        @(posedge clk);

        enqueue = 0;
        dequeue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h20, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("testcase008: Circular buffer wrap around");
        reset_dut();


        enqueue = 1; data_in = 8'h11; @(posedge clk);
        enqueue = 1; data_in = 8'h22; @(posedge clk);
        enqueue = 1; data_in = 8'h33; @(posedge clk);
        enqueue = 0;


        dequeue = 1; @(posedge clk);
        dequeue = 1; @(posedge clk);
        dequeue = 0;


        enqueue = 1; data_in = 8'h44; @(posedge clk);
        enqueue = 1; data_in = 8'h55; @(posedge clk);
        enqueue = 1; data_in = 8'h66; @(posedge clk);
        enqueue = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h33, 1'b0, 1'b1);
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
