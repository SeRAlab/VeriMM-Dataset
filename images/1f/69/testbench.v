`timescale 1ns/1ps

module jpeg_dct_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] pixel_block;
    reg rst;
    reg valid;
    wire [63:0] dct_coeffs;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_dct dut (
        .clk(clk),
        .pixel_block(pixel_block),
        .rst(rst),
        .valid(valid),
        .dct_coeffs(dct_coeffs),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            pixel_block = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Block", test_num);
            reset_dut();

            pixel_block = 64'h0000000000000000;
            valid = 1;
            @(posedge clk);
            valid = 0;


            while (!ready) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Value Block (All 0xFF)", test_num);
            reset_dut();

            pixel_block = 64'hFFFFFFFFFFFFFFFF;
            valid = 1;
            @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;


            #1;



            check_outputs(64'hFF00000000000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            reset_dut();

            pixel_block = 64'hFF00FF00FF00FF00;
            valid = 1;
            @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;


            #1;



            check_outputs(64'h7F0000000000007F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse Input (Single Pixel)", test_num);
            reset_dut();

            pixel_block = 64'h8000000000000000;
            valid = 1;
            @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            #1;


            check_outputs(64'h2D2D2D2D2D2D2D2D, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-Range Uniform Block (All 0x80)", test_num);
            reset_dut();

            pixel_block = 64'h8080808080808080;
            valid = 1;
            @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            #1;


            check_outputs(64'hB500000000000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_dct Testbench");
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
        input [63:0] expected_dct_coeffs;
        input expected_ready;
        begin
            if (expected_dct_coeffs === (expected_dct_coeffs ^ dct_coeffs ^ expected_dct_coeffs) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: dct_coeffs=%h, ready=%b",
                         dct_coeffs, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct_coeffs=%h, ready=%b",
                         expected_dct_coeffs, expected_ready);
                $display("  Got:      dct_coeffs=%h, ready=%b",
                         dct_coeffs, ready);
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
        $dumpvars(0,clk, pixel_block, rst, valid, dct_coeffs, ready);
    end

endmodule
