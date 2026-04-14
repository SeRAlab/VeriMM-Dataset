`timescale 1ns/1ps

module png_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] pixel_in;
    reg pixel_valid;
    wire [7:0] count_out;
    wire [7:0] pixel_out;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compressor dut (
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .count_out(count_out),
        .pixel_out(pixel_out),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_valid = 0;
        forever #5 pixel_valid = ~pixel_valid;
    end

        task reset_dut;

        begin
            pixel_in = 8'h0;

            repeat (2) @(posedge pixel_valid);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic RLE [255, 255, 255, 128]");
            reset_dut();
            test_num = 1;

            pixel_in = 8'd255;
            @(posedge pixel_valid);
            @(posedge pixel_valid);
            @(posedge pixel_valid);

            pixel_in = 8'd128;
            @(posedge pixel_valid);

            #2;
            #1;

            check_outputs(8'd3, 8'd255, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single pixel run [10, 20]");
            reset_dut();
            test_num = 2;

            pixel_in = 8'd10;
            @(posedge pixel_valid);

            pixel_in = 8'd20;
            @(posedge pixel_valid);

            #2;
            #1;

            check_outputs(8'd1, 8'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Maximum count (8) [50, ..., 50, 60]");
            reset_dut();
            test_num = 3;

            pixel_in = 8'd50;
            repeat (8) @(posedge pixel_valid);

            pixel_in = 8'd60;
            @(posedge pixel_valid);

            #2;
            #1;

            check_outputs(8'd8, 8'd50, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary at count 8 [77, ..., 77]");
            reset_dut();
            test_num = 4;

            pixel_in = 8'd77;
            repeat (8) @(posedge pixel_valid);

            pixel_in = 8'd77;
            @(posedge pixel_valid);

            #2;
            #1;

            check_outputs(8'd8, 8'd77, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive runs [1, 1, 2, 2, 3]");
            reset_dut();
            test_num = 5;

            pixel_in = 8'd1;
            @(posedge pixel_valid);
            @(posedge pixel_valid);

            pixel_in = 8'd2;
            @(posedge pixel_valid);

            if (valid_output && count_out == 8'd2 && pixel_out == 8'd1) pass_count = pass_count + 0;

            pixel_in = 8'd2;
            @(posedge pixel_valid);

            pixel_in = 8'd3;
            @(posedge pixel_valid);

            #2;
            #1;

            check_outputs(8'd2, 8'd2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compressor Testbench");
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
        input [7:0] expected_count_out;
        input [7:0] expected_pixel_out;
        input expected_valid_output;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, pixel_out=%h, valid_output=%b",
                         count_out, pixel_out, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, pixel_out=%h, valid_output=%b",
                         expected_count_out, expected_pixel_out, expected_valid_output);
                $display("  Got:      count_out=%h, pixel_out=%h, valid_output=%b",
                         count_out, pixel_out, valid_output);
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
        $dumpvars(0,pixel_in, pixel_valid, count_out, pixel_out, valid_output);
    end

endmodule
