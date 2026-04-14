`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg deq;
    reg enq;
    reg rst;
    wire [7:0] data_out;

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
        .data_out(data_out)
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
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Enqueue and Dequeue");
            reset_dut();


            data_in = 8'hA1;
            enq = 1;
            @(posedge clk);
            enq = 0;


            #1 deq = 1;
            @(posedge clk);
            #1 deq = 0;

            #1;


            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Fill FIFO to capacity and empty it");
            reset_dut();


            enq = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            enq = 0;


            deq = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 deq = 0;

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overflow protection");
            reset_dut();


            enq = 1;
            data_in = 8'hD1; @(posedge clk);
            data_in = 8'hD2; @(posedge clk);
            data_in = 8'hD3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);

            data_in = 8'hFF; @(posedge clk);
            enq = 0;


            deq = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 deq = 0;



            #1;




            check_outputs(8'hD4);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Underflow protection");
            reset_dut();


            deq = 1;
            @(posedge clk);
            deq = 0;


            enq = 1;
            data_in = 8'hBC;
            @(posedge clk);
            enq = 0;


            #1 deq = 1;
            @(posedge clk);
            #1 deq = 0;

            #1;


            check_outputs(8'hBC);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Interleaved Enqueue and Dequeue");
            reset_dut();


            enq = 1;
            data_in = 8'h0A; @(posedge clk);
            data_in = 8'h0B; @(posedge clk);
            enq = 0;


            deq = 1; @(posedge clk);
            deq = 0;


            enq = 1;
            data_in = 8'h0C; @(posedge clk);
            enq = 0;


            deq = 1;
            @(posedge clk);
            @(posedge clk);
            #1 deq = 0;

            #1;


            check_outputs(8'h0C);
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, deq, enq, rst, data_out);
    end

endmodule
