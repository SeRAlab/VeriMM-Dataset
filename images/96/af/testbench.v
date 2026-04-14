`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_en;
    reg reset;
    reg [31:0] write_data;
    reg write_en;
    wire fifo_is_empty;
    wire fifo_is_full;
    wire [31:0] read_data;
    wire [6:0] words_used;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_en(read_en),
        .reset(reset),
        .write_data(write_data),
        .write_en(write_en),
        .fifo_is_empty(fifo_is_empty),
        .fifo_is_full(fifo_is_full),
        .read_data(read_data),
        .words_used(words_used)
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
            write_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 32'h0, 7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write Operation", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            write_data = 32'hDEADBEEF;
            @(negedge clk);
            write_en = 0;


            #1;



            check_outputs(1'b0, 1'b0, 32'h0, 7'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Back", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            write_data = 32'hAAAA_5555;
            @(negedge clk);
            write_en = 0;
            read_en = 1;
            @(negedge clk);
            read_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 32'hAAAA_5555, 7'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill to Capacity", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            for (i = 0; i < 128; i = i + 1) begin
                write_data = i;
                @(negedge clk);
            end
            write_en = 0;


            #1;



            check_outputs(1'b0, 1'b1, 32'h0, 7'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full-to-Empty Sequence", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            for (i = 0; i < 128; i = i + 1) begin
                write_data = i + 32'h100;
                @(negedge clk);
            end
            write_en = 0;


            read_en = 1;
            for (i = 0; i < 127; i = i + 1) begin
                @(negedge clk);
            end

            @(negedge clk);
            read_en = 0;


            #1;



            check_outputs(1'b1, 1'b0, 32'h0000_00E3, 7'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            write_data = 32'h1111_1111;
            @(negedge clk);


            write_data = 32'h2222_2222;
            read_en = 1;
            @(negedge clk);
            write_en = 0;
            read_en = 0;


            #1;



            check_outputs(1'b0, 1'b0, 32'h1111_1111, 7'd1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pointer Wrap-around Logic", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            for (i = 0; i < 100; i = i + 1) begin
                write_data = i;
                @(negedge clk);
            end
            write_en = 0;


            read_en = 1;
            for (i = 0; i < 50; i = i + 1) begin
                @(negedge clk);
            end
            read_en = 0;


            write_en = 1;
            for (i = 0; i < 50; i = i + 1) begin
                write_data = i + 500;
                @(negedge clk);
            end
            write_en = 0;


            #1;



            check_outputs(1'b0, 1'b0, 32'd49, 7'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_fifo_is_empty;
        input expected_fifo_is_full;
        input [31:0] expected_read_data;
        input [6:0] expected_words_used;
        begin
            if (expected_fifo_is_empty === (expected_fifo_is_empty ^ fifo_is_empty ^ expected_fifo_is_empty) &&
                expected_fifo_is_full === (expected_fifo_is_full ^ fifo_is_full ^ expected_fifo_is_full) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_words_used === (expected_words_used ^ words_used ^ expected_words_used)) begin
                $display("PASS");
                $display("  Outputs: fifo_is_empty=%b, fifo_is_full=%b, read_data=%h, words_used=%h",
                         fifo_is_empty, fifo_is_full, read_data, words_used);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_is_empty=%b, fifo_is_full=%b, read_data=%h, words_used=%h",
                         expected_fifo_is_empty, expected_fifo_is_full, expected_read_data, expected_words_used);
                $display("  Got:      fifo_is_empty=%b, fifo_is_full=%b, read_data=%h, words_used=%h",
                         fifo_is_empty, fifo_is_full, read_data, words_used);
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
        $dumpvars(0,clk, read_en, reset, write_data, write_en, fifo_is_empty, fifo_is_full, read_data, words_used);
    end

endmodule
