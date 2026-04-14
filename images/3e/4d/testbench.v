`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg deq;
    reg enq;
    reg rst;
    wire [4:0] data_out;
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-Reset Status", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Enqueue", test_num);
            reset_dut();
            data_in = 5'h0A;
            enq = 1;
            @(posedge clk);
            #1 enq = 0;

            #1;


            check_outputs(5'h0A, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO", test_num);
            reset_dut();

            data_in = 5'h01; enq = 1; @(posedge clk); #1;
            data_in = 5'h02; enq = 1; @(posedge clk); #1;
            data_in = 5'h03; enq = 1; @(posedge clk); #1;
            data_in = 5'h04; enq = 1; @(posedge clk); #1;
            enq = 0;

            #1;


            check_outputs(5'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Partial Dequeue", test_num);
            reset_dut();

            data_in = 5'h01; enq = 1; @(posedge clk); #1;
            data_in = 5'h02; enq = 1; @(posedge clk); #1;
            data_in = 5'h03; enq = 1; @(posedge clk); #1;
            data_in = 5'h04; enq = 1; @(posedge clk); #1;
            enq = 0;

            deq = 1; @(posedge clk); #1;
            deq = 1; @(posedge clk); #1;
            deq = 0;

            #1;


            check_outputs(5'h03, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Fill and Empty", test_num);
            reset_dut();

            data_in = 5'h10; enq = 1; @(posedge clk); #1;
            data_in = 5'h11; enq = 1; @(posedge clk); #1;
            data_in = 5'h12; enq = 1; @(posedge clk); #1;
            data_in = 5'h13; enq = 1; @(posedge clk); #1;
            enq = 0;

            deq = 1; repeat(4) @(posedge clk); #1;
            deq = 0;

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Test", test_num);
            reset_dut();
            enq = 1;
            data_in = 5'h01; @(posedge clk); #1;
            data_in = 5'h02; @(posedge clk); #1;
            data_in = 5'h03; @(posedge clk); #1;
            data_in = 5'h04; @(posedge clk); #1;
            data_in = 5'h05; @(posedge clk); #1;
            enq = 0;

            #1;


            check_outputs(5'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Enq/Deq", test_num);
            reset_dut();

            data_in = 5'h1A; enq = 1; @(posedge clk); #1;

            data_in = 5'h1B; enq = 1; deq = 1; @(posedge clk); #1;
            enq = 0; deq = 0;

            #1;


            check_outputs(5'h1B, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Wrap-around Test", test_num);
            reset_dut();

            data_in = 5'h01; enq = 1; @(posedge clk); #1;
            data_in = 5'h02; enq = 1; @(posedge clk); #1;
            data_in = 5'h03; enq = 1; @(posedge clk); #1;

            enq = 0; deq = 1; repeat(2) @(posedge clk); #1;
            deq = 0;

            enq = 1;
            data_in = 5'h04; @(posedge clk); #1;
            data_in = 5'h05; @(posedge clk); #1;
            data_in = 5'h06; @(posedge clk); #1;
            enq = 0;

            #1;


            check_outputs(5'h03, 1'b0, 1'b1);
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
        input [4:0] expected_data_out;
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
