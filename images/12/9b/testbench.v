`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire [7:0] rle_count;
    wire rle_ready;
    wire [7:0] rle_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .rle_count(rle_count),
        .rle_ready(rle_ready),
        .rle_value(rle_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            data_in = 8'h0;
            data_valid = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic RLE sequence", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'hAA; data_valid = 1;
            @(posedge clk);
            data_in = 8'hAA; data_valid = 1;
            @(posedge clk);
            data_in = 8'hAA; data_valid = 1;
            @(posedge clk);
            data_in = 8'hBB; data_valid = 1;


            #2;
            #1;

            check_outputs(8'd3, 1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single byte run", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h10; data_valid = 1;
            @(posedge clk);
            data_in = 8'h20; data_valid = 1;

            #2;
            #1;

            check_outputs(8'd1, 1'b1, 8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Intermittent data_valid", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h55; data_valid = 1;
            @(posedge clk);
            data_in = 8'h55; data_valid = 0;
            @(posedge clk);
            data_in = 8'h55; data_valid = 1;
            @(posedge clk);
            data_in = 8'h66; data_valid = 1;

            #2;

            #1;


            check_outputs(8'd2, 1'b1, 8'h55);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum count (255)", test_num);
            reset_dut();


            for (i = 0; i < 255; i = i + 1) begin
                @(posedge clk);
                data_in = 8'hCC; data_valid = 1;
            end


            @(posedge clk);
            data_in = 8'hDD; data_valid = 1;

            #2;
            #1;

            check_outputs(8'd255, 1'b1, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-stream", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'hEE; data_valid = 1;
            @(posedge clk);
            data_in = 8'hEE; data_valid = 1;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            @(posedge clk);
            data_in = 8'hFF; data_valid = 1;
            @(posedge clk);
            data_in = 8'h00; data_valid = 1;

            #2;

            #1;


            check_outputs(8'd1, 1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating values", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h01; data_valid = 1;
            @(posedge clk);
            data_in = 8'h02; data_valid = 1;
            @(posedge clk);
            data_in = 8'h03; data_valid = 1;

            #2;

            #1;


            check_outputs(8'd1, 1'b1, 8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [7:0] expected_rle_count;
        input expected_rle_ready;
        input [7:0] expected_rle_value;
        begin
            if (expected_rle_count === (expected_rle_count ^ rle_count ^ expected_rle_count) &&
                expected_rle_ready === (expected_rle_ready ^ rle_ready ^ expected_rle_ready) &&
                expected_rle_value === (expected_rle_value ^ rle_value ^ expected_rle_value)) begin
                $display("PASS");
                $display("  Outputs: rle_count=%h, rle_ready=%b, rle_value=%h",
                         rle_count, rle_ready, rle_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_count=%h, rle_ready=%b, rle_value=%h",
                         expected_rle_count, expected_rle_ready, expected_rle_value);
                $display("  Got:      rle_count=%h, rle_ready=%b, rle_value=%h",
                         rle_count, rle_ready, rle_value);
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
        $dumpvars(0,clk, data_in, data_valid, reset, rle_count, rle_ready, rle_value);
    end

endmodule
