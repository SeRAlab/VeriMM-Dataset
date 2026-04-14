`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg read_en;
    reg rst;
    reg write_en;
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
        .read_en(read_en),
        .rst(rst),
        .write_en(write_en),
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
        write_en = 0;
        read_en = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Checking flags after reset...");

        #1;


        check_outputs(data_out, 1, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Filling FIFO (Depth 4)...");
        @(negedge clk);
        data_in = 5'h01; write_en = 1; @(negedge clk);
        data_in = 5'h02; write_en = 1; @(negedge clk);
        data_in = 5'h03; write_en = 1; @(negedge clk);
        data_in = 5'h04; write_en = 1; @(negedge clk);
        write_en = 0;
        #1;


        #1;



        check_outputs(5'h01, 0, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Filling then Emptying FIFO...");
        @(negedge clk);
        data_in = 5'h1A; write_en = 1; @(negedge clk);
        data_in = 5'h1B; write_en = 1; @(negedge clk);
        data_in = 5'h1C; write_en = 1; @(negedge clk);
        data_in = 5'h1D; write_en = 1; @(negedge clk);
        write_en = 0;


        read_en = 1; @(negedge clk);
        read_en = 1; @(negedge clk);
        read_en = 1; @(negedge clk);
        read_en = 1; @(negedge clk);
        read_en = 0;
        #1;

        #1;


        check_outputs(data_out, 1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Testing Circular/Wrap-around behavior...");
        @(negedge clk);
        data_in = 5'h05; write_en = 1; @(negedge clk);
        data_in = 5'h06; write_en = 1; @(negedge clk);
        write_en = 0;

        read_en = 1; @(negedge clk);
        read_en = 1; @(negedge clk);
        read_en = 0;


        data_in = 5'h11; write_en = 1; @(negedge clk);
        data_in = 5'h12; write_en = 1; @(negedge clk);
        data_in = 5'h13; write_en = 1; @(negedge clk);
        data_in = 5'h14; write_en = 1; @(negedge clk);
        write_en = 0;
        #1;

        #1;


        check_outputs(5'h11, 0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Verify data integrity after mixed operations...");
        @(negedge clk);
        data_in = 5'h0A; write_en = 1; @(negedge clk);
        data_in = 5'h0B; write_en = 1; @(negedge clk);
        write_en = 0;
        read_en = 1; @(negedge clk);
        read_en = 0;
        #1;

        #1;


        check_outputs(5'h0B, 0, 0);
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
        $dumpvars(0,clk, data_in, read_en, rst, write_en, data_out, empty, full);
    end

endmodule
