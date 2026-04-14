`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] enq;
    reg rst;
    wire [7:0] deq;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .enq(enq),
        .rst(rst),
        .deq(deq),
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
            enq = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enq = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enq = 8'h11; @(posedge clk); #1;
            enq = 8'h22; @(posedge clk); #1;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enq = 8'hA1; @(posedge clk); #1;
            enq = 8'hA2; @(posedge clk); #1;
            enq = 8'hA3; @(posedge clk); #1;
            enq = 8'hA4; @(posedge clk); #1;

            #1;


            check_outputs(8'hA1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enq = 8'h10; @(posedge clk); #1;
            enq = 8'h20; @(posedge clk); #1;
            enq = 8'h30; @(posedge clk); #1;
            enq = 8'h40; @(posedge clk); #1;
            enq = 8'h50; @(posedge clk); #1;

            #1;


            check_outputs(8'h10, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            enq = 8'hFF; @(posedge clk);
            enq = 8'hFF; @(posedge clk);
            enq = 8'hFF; @(posedge clk);
            enq = 8'hFF; @(posedge clk); #1;

            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
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
        input [7:0] expected_deq;
        input expected_empty;
        input expected_full;
        begin
            if (expected_deq === (expected_deq ^ deq ^ expected_deq) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: deq=%h, empty=%b, full=%b",
                         deq, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deq=%h, empty=%b, full=%b",
                         expected_deq, expected_empty, expected_full);
                $display("  Got:      deq=%h, empty=%b, full=%b",
                         deq, empty, full);
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
        $dumpvars(0,clk, enq, rst, deq, empty, full);
    end

endmodule
