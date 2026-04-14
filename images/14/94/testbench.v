`timescale 1ns/1ps

module RLE_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] pixel_in;
    reg rst;
    wire [31:0] compressed_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Compressor dut (
        .clk(clk),
        .pixel_in(pixel_in),
        .rst(rst),
        .compressed_out(compressed_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pixel_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 consecutive Red pixels", test_num);
            reset_dut();

            pixel_in <= 24'hFF0000;
            repeat(3) @(posedge clk);

            pixel_in <= 24'h0000FF;
            @(posedge clk);

            #1;
            #1;

            check_outputs({8'd3, 24'hFF0000}, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8 consecutive Green pixels (Max Count)", test_num);
            reset_dut();

            pixel_in <= 24'h00FF00;
            repeat(8) @(posedge clk);

            #1;

            #1;


            check_outputs({8'd8, 24'h00FF00}, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single White pixel followed by change", test_num);
            reset_dut();

            pixel_in <= 24'hFFFFFF;
            @(posedge clk);

            pixel_in <= 24'h000000;
            @(posedge clk);

            #1;
            #1;

            check_outputs({8'd1, 24'hFFFFFF}, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 9 Blue pixels (Split run)", test_num);
            reset_dut();

            pixel_in <= 24'h0000FF;
            repeat(8) @(posedge clk);


            #1;
            if (valid && compressed_out === {8'd8, 24'h0000FF}) begin

                @(posedge clk);
                pixel_in <= 24'hFF00FF;
                @(posedge clk);
                #1;
                #1;

                check_outputs({8'd1, 24'h0000FF}, 1'b1);
            end else begin
                $display("FAIL: Initial 8-count run failed.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid color changes", test_num);
            reset_dut();

            pixel_in <= 24'hAAAAAA; @(posedge clk);
            pixel_in <= 24'hBBBBBB; @(posedge clk);
            pixel_in <= 24'hCCCCCC; @(posedge clk);

            #1;

            #1;


            check_outputs({8'd1, 24'hBBBBBB}, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during run", test_num);
            reset_dut();

            pixel_in <= 24'h123456;
            repeat(4) @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            pixel_in <= 24'h654321;
            @(posedge clk);
            pixel_in <= 24'h000000;
            @(posedge clk);

            #1;

            #1;


            check_outputs({8'd1, 24'h654321}, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Compressor Testbench");
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
        input [31:0] expected_compressed_out;
        input expected_valid;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, valid=%b",
                         compressed_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, valid=%b",
                         expected_compressed_out, expected_valid);
                $display("  Got:      compressed_out=%h, valid=%b",
                         compressed_out, valid);
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
        $dumpvars(0,clk, pixel_in, rst, compressed_out, valid);
    end

endmodule
