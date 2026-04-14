`timescale 1ns/1ps

module jpeg_rle_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] pixel_in;
    reg rst;
    reg valid;
    wire out_valid;
    wire [7:0] pixel_out;
    wire [7:0] run_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_rle_compression dut (
        .clk(clk),
        .pixel_in(pixel_in),
        .rst(rst),
        .valid(valid),
        .out_valid(out_valid),
        .pixel_out(pixel_out),
        .run_count(run_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pixel_in = 8'h0;
            valid = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Run of 5 pixels", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk);
                pixel_in = 8'hAA;
                valid = 1;
            end


            @(posedge clk);
            pixel_in = 8'hBB;
            valid = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hAA, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single pixel run", test_num);
            reset_dut();

            @(posedge clk);
            pixel_in = 8'h11;
            valid = 1;

            @(posedge clk);
            pixel_in = 8'h22;
            valid = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'h11, 8'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum run length (255)", test_num);
            reset_dut();

            repeat(255) begin
                @(posedge clk);
                pixel_in = 8'hFF;
                valid = 1;
            end

            @(posedge clk);
            pixel_in = 8'h00;
            valid = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hFF, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid signal gating test", test_num);
            reset_dut();

            @(posedge clk);
            pixel_in = 8'hCC;
            valid = 1;

            @(posedge clk);
            pixel_in = 8'hCC;
            valid = 0;

            @(posedge clk);
            pixel_in = 8'hCC;
            valid = 1;

            @(posedge clk);
            pixel_in = 8'hDD;
            valid = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'hCC, 8'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            pixel_in = 8'hEE;
            valid = 1;

            @(posedge clk);
            pixel_in = 8'hEE;
            valid = 1;


            @(posedge clk);
            rst = 1;

            @(posedge clk);
            rst = 0;
            pixel_in = 8'h55;
            valid = 1;

            @(posedge clk);
            pixel_in = 8'h66;
            valid = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'h55, 8'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_rle_compression Testbench");
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
        input expected_out_valid;
        input [7:0] expected_pixel_out;
        input [7:0] expected_run_count;
        begin
            if (expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out) &&
                expected_run_count === (expected_run_count ^ run_count ^ expected_run_count)) begin
                $display("PASS");
                $display("  Outputs: out_valid=%b, pixel_out=%h, run_count=%h",
                         out_valid, pixel_out, run_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_valid=%b, pixel_out=%h, run_count=%h",
                         expected_out_valid, expected_pixel_out, expected_run_count);
                $display("  Got:      out_valid=%b, pixel_out=%h, run_count=%h",
                         out_valid, pixel_out, run_count);
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
        $dumpvars(0,clk, pixel_in, rst, valid, out_valid, pixel_out, run_count);
    end

endmodule
