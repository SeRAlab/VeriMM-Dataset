`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] x3;
    wire [7:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
        .rst(rst),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            x1 = 0; x2 = 0; y1 = 0; y2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State Initialization", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Point Addition (5, 1) + (6, 3)", test_num);
            reset_dut();
            @(posedge clk);
            x1 = 8'd5; y1 = 8'd1;
            x2 = 8'd6; y2 = 8'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A, 8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Point Doubling 2 * (5, 1)", test_num);
            reset_dut();
            @(posedge clk);
            x1 = 8'd5; y1 = 8'd1;
            x2 = 8'd5; y2 = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h06, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Point Doubling 2 * (13, 10)", test_num);
            reset_dut();
            @(posedge clk);
            x1 = 8'd13; y1 = 8'd10;
            x2 = 8'd13; y2 = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A, 8'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Point + Inverse (5, 1) + (5, 16)", test_num);
            reset_dut();
            @(posedge clk);
            x1 = 8'd5; y1 = 8'd1;
            x2 = 8'd5; y2 = 8'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_addition Testbench");
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
        input [7:0] expected_x3;
        input [7:0] expected_y3;
        begin
            if (expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: x3=%h, y3=%h",
                         x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x3=%h, y3=%h",
                         expected_x3, expected_y3);
                $display("  Got:      x3=%h, y3=%h",
                         x3, y3);
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
        $dumpvars(0,clk, rst, x1, x2, y1, y2, x3, y3);
    end

endmodule
