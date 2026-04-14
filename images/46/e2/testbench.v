`timescale 1ns/1ps

module fifo_buffer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg deq;
    reg enq;
    reg rst;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_buffer dut (
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
            rst = 0;
            enq = 0;
            deq = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data_in = 8'h55;
            enq = 1;
            @(posedge clk);
            #1 enq = 0;


            deq = 1;
            @(posedge clk);
            #1 deq = 0;


            #1;



            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enq = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 1;
                @(posedge clk);
            end
            #1 enq = 0;

            #1;


            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            enq = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 8'hA0;
                @(posedge clk);
            end
            #1 enq = 0;

            deq = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1 deq = 0;

            #1;


            check_outputs(8'hAF, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enq = 1;

            for (i = 0; i < 17; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 enq = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            data_in = 8'hCC;
            enq = 1;
            @(posedge clk);
            #1;

            data_in = 8'hDD;
            enq = 1;
            deq = 1;
            @(posedge clk);
            #1;
            enq = 0;
            deq = 0;


            #1;



            check_outputs(8'hDD, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_buffer Testbench");
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
        $dumpvars(0,clk, data_in, deq, enq, rst, data_out, empty, full);
    end

endmodule
