`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg [7:0] x_im0;
    reg [7:0] x_im1;
    reg [7:0] x_im2;
    reg [7:0] x_im3;
    reg [7:0] x_re0;
    reg [7:0] x_re1;
    reg [7:0] x_re2;
    reg [7:0] x_re3;
    wire done;
    wire [15:0] y_im0;
    wire [15:0] y_im1;
    wire [15:0] y_im2;
    wire [15:0] y_im3;
    wire [15:0] y_re0;
    wire [15:0] y_re1;
    wire [15:0] y_re2;
    wire [15:0] y_re3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .start(start),
        .x_im0(x_im0),
        .x_im1(x_im1),
        .x_im2(x_im2),
        .x_im3(x_im3),
        .x_re0(x_re0),
        .x_re1(x_re1),
        .x_re2(x_re2),
        .x_re3(x_re3),
        .done(done),
        .y_im0(y_im0),
        .y_im1(y_im1),
        .y_im2(y_im2),
        .y_im3(y_im3),
        .y_re0(y_re0),
        .y_re1(y_re1),
        .y_re2(y_re2),
        .y_re3(y_re3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            x_re0 = 0; x_im0 = 0;
            x_re1 = 0; x_im1 = 0;
            x_re2 = 0; x_im2 = 0;
            x_re3 = 0; x_im3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Unit Impulse at x[0]");
            x_re0 = 8'd10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            #1 #1;
 check_outputs(1'b1, 16'd0, 16'd0, 16'd0, 16'd0, 16'd10, 16'd10, 16'd10, 16'd10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: DC Signal");
            x_re0 = 8'd5; x_re1 = 8'd5; x_re2 = 8'd5; x_re3 = 8'd5;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            #1 #1;
 check_outputs(1'b1, 16'd0, 16'd0, 16'd0, 16'd0, 16'd20, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Complex Sinusoid k=1");
            x_re0 = 8'd1;  x_im0 = 8'd0;
            x_re1 = 8'd0;  x_im1 = 8'd1;
            x_re2 = 8'hFF; x_im2 = 8'd0;
            x_re3 = 8'd0;  x_im3 = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            #1 #1;
 check_outputs(1'b1, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd4, 16'd0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: General Complex Values");
            x_re0 = 8'd2;   x_im0 = 8'd1;
            x_re1 = 8'hFF;  x_im1 = 8'd3;
            x_re2 = 8'd4;   x_im2 = 8'hFE;
            x_re3 = 8'd0;   x_im3 = 8'd0;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            #1 #1;
 check_outputs(1'b1, 16'd2, 16'd4, 16'hFFFC, 16'd2, 16'd5, 16'd1, 16'd7, 16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Negative DC Signal");
            x_re0 = 8'hF6; x_re1 = 8'hF6; x_re2 = 8'hF6; x_re3 = 8'hF6;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            #1 #1;
 check_outputs(1'b1, 16'd0, 16'd0, 16'd0, 16'd0, 16'hFFD8, 16'd0, 16'd0, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input expected_done;
        input [15:0] expected_y_im0;
        input [15:0] expected_y_im1;
        input [15:0] expected_y_im2;
        input [15:0] expected_y_im3;
        input [15:0] expected_y_re0;
        input [15:0] expected_y_re1;
        input [15:0] expected_y_re2;
        input [15:0] expected_y_re3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_y_im0 === (expected_y_im0 ^ y_im0 ^ expected_y_im0) &&
                expected_y_im1 === (expected_y_im1 ^ y_im1 ^ expected_y_im1) &&
                expected_y_im2 === (expected_y_im2 ^ y_im2 ^ expected_y_im2) &&
                expected_y_im3 === (expected_y_im3 ^ y_im3 ^ expected_y_im3) &&
                expected_y_re0 === (expected_y_re0 ^ y_re0 ^ expected_y_re0) &&
                expected_y_re1 === (expected_y_re1 ^ y_re1 ^ expected_y_re1) &&
                expected_y_re2 === (expected_y_re2 ^ y_re2 ^ expected_y_re2) &&
                expected_y_re3 === (expected_y_re3 ^ y_re3 ^ expected_y_re3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         done, y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         expected_done, expected_y_im0, expected_y_im1, expected_y_im2, expected_y_im3, expected_y_re0, expected_y_re1, expected_y_re2, expected_y_re3);
                $display("  Got:      done=%b, y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         done, y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
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
        $dumpvars(0,clk, start, x_im0, x_im1, x_im2, x_im3, x_re0, x_re1, x_re2, x_re3, done, y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
    end

endmodule
