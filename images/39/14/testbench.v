`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg reset;
    reg write_en;
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
        .read_en(read_en),
        .reset(reset),
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
            reset = 1;
            write_en = 0;
            read_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(8'hxx, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Write and Read");
            reset_dut();


            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;


            #1;



            check_outputs(8'hAA, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Fill FIFO to Depth 4");
            reset_dut();

            write_en = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            #1 write_en = 0;


            #1;



            check_outputs(8'hxx, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Fill Full and then Read All");
            reset_dut();


            write_en = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 read_en = 0;


            #1;



            check_outputs(8'h04, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Overflow Test (Write 5 items)");
            reset_dut();

            write_en = 1;
            data_in = 8'hD1; @(posedge clk);
            data_in = 8'hD2; @(posedge clk);
            data_in = 8'hD3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);
            data_in = 8'hD5; @(posedge clk);
            #1 write_en = 0;


            #1;



            check_outputs(8'hxx, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Simultaneous Read and Write");
            reset_dut();


            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            write_en = 1;
            data_in = 8'h66;
            @(posedge clk);
            #1 read_en = 0; write_en = 0;



            #1;




            check_outputs(8'h55, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Underflow Test (Read empty)");
            reset_dut();

            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;


            #1;



            check_outputs(8'hxx, 1, 0);
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
        $dumpvars(0,clk, data_in, read_en, reset, write_en, data_out, empty, full);
    end

endmodule
