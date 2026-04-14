`timescale 1ns/1ps

module jpeg_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] pixel_in;
    wire [7:0] compressed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compressor dut (
        .clk(clk),
        .enable(enable),
        .pixel_in(pixel_in),
        .compressed_out(compressed_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            pixel_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant pixel values (128)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(8) begin
                pixel_in = 8'd128;
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Varying pixels (10, 20, ..., 80)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                pixel_in = i * 10;
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(8'h2D);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum pixel values (255)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(8) begin
                pixel_in = 8'hFF;
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation check (Sum 63)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            pixel_in = 8'd7; @(posedge clk);
            repeat(7) begin
                pixel_in = 8'd8; @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zero pixels", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(8) begin
                pixel_in = 8'h00;
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal behavior (Pausing counter)", test_num);
            reset_dut();
            @(posedge clk);

            enable = 1;
            repeat(4) begin
                pixel_in = 8'd40;
                @(posedge clk);
            end

            enable = 0;
            pixel_in = 8'd255;
            repeat(3) @(posedge clk);

            enable = 1;
            repeat(4) begin
                pixel_in = 8'd40;
                @(posedge clk);
            end

            enable = 0;
            #1;
            #1;

            check_outputs(8'h28);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_compressor Testbench");
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
        input [7:0] expected_compressed_out;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h",
                         compressed_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h",
                         expected_compressed_out);
                $display("  Got:      compressed_out=%h",
                         compressed_out);
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
        $dumpvars(0,clk, enable, pixel_in, compressed_out);
    end

endmodule
