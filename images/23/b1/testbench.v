`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg deq;
    reg enq;
    reg rst;
    wire [3:0] data_out;
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
        .deq(deq),
        .enq(enq),
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
            enq = 0;
            deq = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State Check");
            test_num = 1;
            reset_dut();

            #1 #1;
 check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Fill FIFO Check");
            test_num = 2;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                enq = 1;
                data_in = i;
                @(posedge clk);
            end
            enq = 0;

            #1 #1;
 check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Drain FIFO Check");
            test_num = 3;
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                enq = 1; data_in = i; @(posedge clk);
            end
            enq = 0;

            for (i = 0; i < 8; i = i + 1) begin
                deq = 1; @(posedge clk);
                #1 deq = 0;
            end

            #1 #1;
 check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Integrity Check");
            test_num = 4;
            reset_dut();


            enq = 1; data_in = 4'hA; @(posedge clk);
            enq = 1; data_in = 4'hB; @(posedge clk);
            enq = 0;


            deq = 1; @(posedge clk);
            #1 deq = 0;


            #1 #1;
 check_outputs(4'hB, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Enq/Deq Check");
            test_num = 5;
            reset_dut();


            enq = 1; data_in = 4'h5; @(posedge clk);
            enq = 0;


            enq = 1; data_in = 4'h6;
            deq = 1;
            @(posedge clk);
            #1 enq = 0; deq = 0;


            #1 #1;
 check_outputs(4'h6, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Overflow Check");
            test_num = 6;
            reset_dut();

            enq = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            enq = 0;

            #1 #1;
 check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Underflow Check");
            test_num = 7;
            reset_dut();

            deq = 1;
            @(posedge clk);
            #1 deq = 0;

            #1 #1;
 check_outputs(data_out, 1'b1, 1'b0);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, deq, enq, rst, data_out, empty, full);
    end

endmodule
