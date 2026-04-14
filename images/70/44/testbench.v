`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [31:0] data_i;
    reg deq_i;
    reg enq_i;
    reg rst_i;
    wire [6:0] count_o;
    wire [31:0] data_o;
    wire full_o;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .data_i(data_i),
        .deq_i(deq_i),
        .enq_i(enq_i),
        .rst_i(rst_i),
        .count_o(count_o),
        .data_o(data_o),
        .full_o(full_o),
        .valid_o(valid_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            enq_i = 0;
            deq_i = 0;
            data_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(7'd0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Enqueue", test_num);
            reset_dut();
            data_i = 32'hDEADBEEF;
            enq_i = 1;
            @(posedge clk_i);
            #1 enq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd1, 32'hDEADBEEF, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Enqueue then Dequeue", test_num);
            reset_dut();

            data_i = 32'hAAAA_AAAA;
            enq_i = 1;
            @(posedge clk_i);
            #1 enq_i = 0;

            deq_i = 1;
            @(posedge clk_i);
            #1 deq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: FIFO ordering", test_num);
            reset_dut();

            data_i = 32'h1; enq_i = 1; @(posedge clk_i);
            data_i = 32'h2; enq_i = 1; @(posedge clk_i);
            data_i = 32'h3; enq_i = 1; @(posedge clk_i);
            #1 enq_i = 0;

            deq_i = 1; @(posedge clk_i);
            deq_i = 1; @(posedge clk_i);
            #1 deq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd1, 32'h3, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %03d: Fill to Capacity", test_num);
            reset_dut();
            enq_i = 1;
            for (i = 1; i <= 64; i = i + 1) begin
                data_i = i;
                @(posedge clk_i);
            end
            #1 enq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd64, 32'h1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %03d: Fill and Empty", test_num);
            reset_dut();
            enq_i = 1;
            for (i = 1; i <= 64; i = i + 1) begin
                data_i = i;
                @(posedge clk_i);
            end
            #1 enq_i = 0; deq_i = 1;
            repeat(64) @(posedge clk_i);
            #1 deq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Simultaneous Enq/Deq", test_num);
            reset_dut();

            enq_i = 1;
            for (integer i = 1; i <= 5; i = i + 1) begin
                data_i = i;
                @(posedge clk_i);
            end

            data_i = 32'h6;
            enq_i = 1;
            deq_i = 1;
            @(posedge clk_i);
            #1 enq_i = 0; deq_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(7'd5, 32'h2, 1'b0, 1'b1);
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
        input [6:0] expected_count_o;
        input [31:0] expected_data_o;
        input expected_full_o;
        input expected_valid_o;
        begin
            if (expected_count_o === (expected_count_o ^ count_o ^ expected_count_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_full_o === (expected_full_o ^ full_o ^ expected_full_o) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: count_o=%h, data_o=%h, full_o=%b, valid_o=%b",
                         count_o, data_o, full_o, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_o=%h, data_o=%h, full_o=%b, valid_o=%b",
                         expected_count_o, expected_data_o, expected_full_o, expected_valid_o);
                $display("  Got:      count_o=%h, data_o=%h, full_o=%b, valid_o=%b",
                         count_o, data_o, full_o, valid_o);
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
        $dumpvars(0,clk_i, data_i, deq_i, enq_i, rst_i, count_o, data_o, full_o, valid_o);
    end

endmodule
