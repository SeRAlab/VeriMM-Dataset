`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            x_re0 = 0; x_im0 = 0;
            x_re1 = 0; x_im1 = 0;
            x_re2 = 0; x_im2 = 0;
            x_re3 = 0; x_im3 = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Impulse Input [1, 0, 0, 0]");

            x_re0 = 8'h01; x_im0 = 8'h00;
            x_re1 = 8'h00; x_im1 = 8'h00;
            x_re2 = 8'h00; x_im2 = 8'h00;
            x_re3 = 8'h00; x_im3 = 8'h00;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h0000, 16'h0000, 16'h0000, 16'h0000,
                                16'h0001, 16'h0001, 16'h0001, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: DC Input [1, 1, 1, 1]");

            x_re0 = 8'h01; x_im0 = 8'h00;
            x_re1 = 8'h01; x_im1 = 8'h00;
            x_re2 = 8'h01; x_im2 = 8'h00;
            x_re3 = 8'h01; x_im3 = 8'h00;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h0000, 16'h0000, 16'h0000, 16'h0000,
                                16'h0004, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Real Sequence [1, 2, 3, 4]");

            x_re0 = 8'd1; x_im0 = 8'd0;
            x_re1 = 8'd2; x_im1 = 8'd0;
            x_re2 = 8'd3; x_im2 = 8'd0;
            x_re3 = 8'd4; x_im3 = 8'd0;

            wait(done);
            @(posedge clk);



            #1;




            check_outputs(1'b1, 16'h0000, 16'h0002, 16'h0000, 16'hFFFE,
                                16'h000A, 16'hFFFE, 16'hFFFE, 16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Complex Impulse [1+j, 0, 0, 0]");

            x_re0 = 8'h01; x_im0 = 8'h01;
            x_re1 = 8'h00; x_im1 = 8'h00;
            x_re2 = 8'h00; x_im2 = 8'h00;
            x_re3 = 8'h00; x_im3 = 8'h00;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 16'h0001, 16'h0001, 16'h0001, 16'h0001,
                                16'h0001, 16'h0001, 16'h0001, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Alternating Sequence [1, -1, 1, -1]");

            x_re0 = 8'h01; x_im0 = 8'h00;
            x_re1 = 8'hFF; x_im1 = 8'h00;
            x_re2 = 8'h01; x_im2 = 8'h00;
            x_re3 = 8'hFF; x_im3 = 8'h00;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 16'h0000, 16'h0000, 16'h0000, 16'h0000,
                                16'h0000, 16'h0000, 16'h0004, 16'h0000);
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
        $dumpvars(0,clk, rst, x_im0, x_im1, x_im2, x_im3, x_re0, x_re1, x_re2, x_re3, done, y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
    end

endmodule
