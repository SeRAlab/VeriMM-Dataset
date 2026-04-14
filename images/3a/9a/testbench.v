`timescale 1ns/1ps

module jpeg_dct_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg reset;
    wire [15:0] dct_00;
    wire [15:0] dct_01;
    wire [15:0] dct_10;
    wire [15:0] dct_11;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_dct dut (
        .clk(clk),
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .reset(reset),
        .dct_00(dct_00),
        .dct_01(dct_01),
        .dct_10(dct_10),
        .dct_11(dct_11),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pixel_00 = 0;
            pixel_01 = 0;
            pixel_10 = 0;
            pixel_11 = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            reset_dut();
            pixel_00 = 8'd0;
            pixel_01 = 8'd0;
            pixel_10 = 8'd0;
            pixel_11 = 8'd0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Value (128)", test_num);
            reset_dut();
            pixel_00 = 8'd128;
            pixel_01 = 8'd128;
            pixel_10 = 8'd128;
            pixel_11 = 8'd128;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0200, 16'h0000, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal Variation", test_num);
            reset_dut();
            pixel_00 = 8'd100;
            pixel_01 = 8'd0;
            pixel_10 = 8'd100;
            pixel_11 = 8'd0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00C8, 16'h00C8, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertical Variation", test_num);
            reset_dut();
            pixel_00 = 8'd100;
            pixel_01 = 8'd100;
            pixel_10 = 8'd0;
            pixel_11 = 8'd0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00C8, 16'h0000, 16'h00C8, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Diagonal Checkerboard", test_num);
            reset_dut();
            pixel_00 = 8'd255;
            pixel_01 = 8'd0;
            pixel_10 = 8'd0;
            pixel_11 = 8'd255;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01FE, 16'h0000, 16'h0000, 16'h01FE, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values", test_num);
            reset_dut();
            pixel_00 = 8'd255;
            pixel_01 = 8'd255;
            pixel_10 = 8'd255;
            pixel_11 = 8'd255;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h03FC, 16'h0000, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative AC Result", test_num);
            reset_dut();
            pixel_00 = 8'd0;
            pixel_01 = 8'd100;
            pixel_10 = 8'd100;
            pixel_11 = 8'd0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00C8, 16'h0000, 16'h0000, 16'hFF38, 1'b1);
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
        input [15:0] expected_dct_00;
        input [15:0] expected_dct_01;
        input [15:0] expected_dct_10;
        input [15:0] expected_dct_11;
        input expected_done;
        begin
            if (expected_dct_00 === (expected_dct_00 ^ dct_00 ^ expected_dct_00) &&
                expected_dct_01 === (expected_dct_01 ^ dct_01 ^ expected_dct_01) &&
                expected_dct_10 === (expected_dct_10 ^ dct_10 ^ expected_dct_10) &&
                expected_dct_11 === (expected_dct_11 ^ dct_11 ^ expected_dct_11) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h, done=%b",
                         dct_00, dct_01, dct_10, dct_11, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h, done=%b",
                         expected_dct_00, expected_dct_01, expected_dct_10, expected_dct_11, expected_done);
                $display("  Got:      dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h, done=%b",
                         dct_00, dct_01, dct_10, dct_11, done);
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
        $dumpvars(0,clk, pixel_00, pixel_01, pixel_10, pixel_11, reset, dct_00, dct_01, dct_10, dct_11, done);
    end

endmodule
