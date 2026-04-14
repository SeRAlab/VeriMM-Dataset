`timescale 1ns/1ps

module png_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg compress;
    reg [7:0] pixel_data;
    reg rst;
    wire [15:0] compressed_data;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compression dut (
        .clk(clk),
        .compress(compress),
        .pixel_data(pixel_data),
        .rst(rst),
        .compressed_data(compressed_data),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            compress = 0;
            pixel_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: 5 identical pixels...");
            test_num = test_num + 1;
            reset_dut();


            repeat(5) begin
                pixel_data = 8'hA5;
                @(posedge clk);
            end


            compress = 1;
            @(posedge clk);
            compress = 0;


            @(posedge clk);
            #1;

            check_outputs(16'h05A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single pixel compression...");
            test_num = test_num + 1;
            reset_dut();

            pixel_data = 8'h12;
            @(posedge clk);

            compress = 1;
            @(posedge clk);
            compress = 0;

            @(posedge clk);
            #1;

            check_outputs(16'h0112, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Max run (255 pixels)...");
            test_num = test_num + 1;
            reset_dut();

            repeat(255) begin
                pixel_data = 8'hFF;
                @(posedge clk);
            end

            compress = 1;
            @(posedge clk);
            compress = 0;

            @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Compression of 0x00 values...");
            test_num = test_num + 1;
            reset_dut();

            repeat(10) begin
                pixel_data = 8'h00;
                @(posedge clk);
            end

            compress = 1;
            @(posedge clk);
            compress = 0;

            @(posedge clk);
            #1;

            check_outputs(16'h0A00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset verification...");
            test_num = test_num + 1;
            reset_dut();

            pixel_data = 8'hCC;
            repeat(3) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Valid signal behavior...");
            test_num = test_num + 1;
            reset_dut();


            compress = 1;
            @(posedge clk);
            compress = 0;
            @(posedge clk);


            if (data_valid === 1'b1)
                $display("System produced output for empty stream.");
            else
                $display("System remained idle for empty stream.");

            pass_count = pass_count + 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compression Testbench");
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
        input [15:0] expected_compressed_data;
        input expected_data_valid;
        begin
            if (expected_compressed_data === (expected_compressed_data ^ compressed_data ^ expected_compressed_data) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_data=%h, data_valid=%b",
                         compressed_data, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_data=%h, data_valid=%b",
                         expected_compressed_data, expected_data_valid);
                $display("  Got:      compressed_data=%h, data_valid=%b",
                         compressed_data, data_valid);
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
        $dumpvars(0,clk, compress, pixel_data, rst, compressed_data, data_valid);
    end

endmodule
