`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data_in;
    reg pop;
    reg push;
    reg wb_clk;
    reg wb_rst;
    wire [31:0] data_out;
    wire empty;
    wire full;
    wire [7:0] number_samples;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .wb_clk(wb_clk),
        .wb_rst(wb_rst),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .number_samples(number_samples)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk = 0;
        forever #5 wb_clk = ~wb_clk;
    end

        task reset_dut;

        begin
            wb_rst = 1;
            push = 0;
            pop = 0;
            data_in = 32'h0;
            test_num = test_num + 1;
            repeat(2) @(posedge wb_clk);
            wb_rst = 0;
            @(posedge wb_clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase%03d: Reset State Check", test_num + 1);
            reset_dut();


            #1;



            check_outputs(32'h0, 1'b1, 1'b0, 8'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase%03d: Single Push Check", test_num + 1);
            reset_dut();
            data_in = 32'hAAAA_BBBB;
            push = 1;
            @(posedge wb_clk);
            push = 0;
            @(posedge wb_clk);

            #1;


            check_outputs(32'hAAAA_BBBB, 1'b0, 1'b0, 8'h1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase%03d: Multiple Pushes Check", test_num + 1);
            reset_dut();


            data_in = 32'h1111_1111; push = 1;
            @(posedge wb_clk);

            data_in = 32'h2222_2222; push = 1;
            @(posedge wb_clk);

            data_in = 32'h3333_3333; push = 1;
            @(posedge wb_clk);
            push = 0;
            @(posedge wb_clk);


            #1;



            check_outputs(32'h1111_1111, 1'b0, 1'b0, 8'h3);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase%03d: Push and Pop Check", test_num + 1);
            reset_dut();


            data_in = 32'h1; push = 1; @(posedge wb_clk);
            data_in = 32'h2; push = 1; @(posedge wb_clk);
            data_in = 32'h3; push = 1; @(posedge wb_clk);
            push = 0;
            @(posedge wb_clk);


            pop = 1;
            @(posedge wb_clk);
            pop = 0;
            @(posedge wb_clk);


            #1;



            check_outputs(32'h2, 1'b0, 1'b0, 8'h2);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase%03d: Fill and Empty Check", test_num + 1);
            reset_dut();


            data_in = 32'hA; push = 1; @(posedge wb_clk);
            data_in = 32'hB; push = 1; @(posedge wb_clk);
            push = 0; @(posedge wb_clk);


            pop = 1; @(posedge wb_clk);

            pop = 1; @(posedge wb_clk);
            pop = 0;
            @(posedge wb_clk);


            #1;



            check_outputs(32'hB, 1'b1, 1'b0, 8'h0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase%03d: Multi-item Depth Count Check", test_num + 1);
            reset_dut();


            push = 1;
            data_in = 32'h1; @(posedge wb_clk);
            data_in = 32'h2; @(posedge wb_clk);
            data_in = 32'h3; @(posedge wb_clk);
            data_in = 32'h4; @(posedge wb_clk);
            data_in = 32'h5; @(posedge wb_clk);
            data_in = 32'h6; @(posedge wb_clk);
            data_in = 32'h7; @(posedge wb_clk);
            data_in = 32'h8; @(posedge wb_clk);
            push = 0;
            @(posedge wb_clk);


            #1;



            check_outputs(32'h1, 1'b0, 1'b0, 8'h8);
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
        input [31:0] expected_data_out;
        input expected_empty;
        input expected_full;
        input [7:0] expected_number_samples;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_number_samples === (expected_number_samples ^ number_samples ^ expected_number_samples)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b, number_samples=%h",
                         data_out, empty, full, number_samples);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b, number_samples=%h",
                         expected_data_out, expected_empty, expected_full, expected_number_samples);
                $display("  Got:      data_out=%h, empty=%b, full=%b, number_samples=%h",
                         data_out, empty, full, number_samples);
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
        $dumpvars(0,data_in, pop, push, wb_clk, wb_rst, data_out, empty, full, number_samples);
    end

endmodule
