`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_enable;
    reg rst;
    reg write_enable;
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
        .read_enable(read_enable),
        .rst(rst),
        .write_enable(write_enable),
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
            write_enable = 0;
            read_enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial State");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Enqueue");
            reset_dut();
            write_enable = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Fill FIFO");
            reset_dut();
            write_enable = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Fill and Empty Entirely");
            reset_dut();

            write_enable = 1;
            data_in = 8'hA1; @(posedge clk);
            data_in = 8'hB2; @(posedge clk);
            data_in = 8'hC3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);
            #1; write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1; read_enable = 0;

            #1;


            check_outputs(8'hD4, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Overflow Check");
            reset_dut();
            write_enable = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            #1; write_enable = 0;

            #1;


            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Underflow Check");
            reset_dut();
            read_enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1; read_enable = 0;

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Interleaved Operations");
            reset_dut();

            write_enable = 1;
            data_in = 8'h10; @(posedge clk);
            data_in = 8'h20; @(posedge clk);
            #1; write_enable = 0;

            read_enable = 1; @(posedge clk);
            #1; read_enable = 0;

            write_enable = 1; data_in = 8'h30; @(posedge clk);
            #1; write_enable = 0;

            #1;


            check_outputs(8'h20, 1'b0, 1'b0);
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
        $dumpvars(0,clk, data_in, read_enable, rst, write_enable, data_out, empty, full);
    end

endmodule
