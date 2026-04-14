`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_enable;
    reg reset;
    reg write_enable;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .reset(reset),
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
            reset = 1;
            data_in = 0;
            write_enable = 0;
            read_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write and Read");
            reset_dut();


            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            read_enable = 0;

            #1;
            #1;

            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill to Full");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 1;
                write_enable = 1;
                @(posedge clk);
            end
            write_enable = 0;

            #1;

            #1;


            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Fill then Empty");
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                data_in = i;
                write_enable = 1;
                @(posedge clk);
            end
            write_enable = 0;


            for (i = 0; i < 16; i = i + 1) begin
                read_enable = 1;
                @(posedge clk);
            end
            read_enable = 0;

            #1;

            #1;


            check_outputs(8'd15, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Pointer Wrap-around");
            reset_dut();


            write_enable = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = i; @(posedge clk);
            end
            write_enable = 0;


            read_enable = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            read_enable = 0;


            write_enable = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 50; @(posedge clk);
            end
            write_enable = 0;

            #1;

            #1;


            check_outputs(8'd50, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        $dumpvars(0,clk, data_in, read_enable, reset, write_enable, data_out, empty, full);
    end

endmodule
