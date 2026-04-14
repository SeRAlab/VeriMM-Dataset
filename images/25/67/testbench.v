`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg valid;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire valid_out;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .valid_out(valid_out),
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
            rst = 1;
            valid = 0;
            x1 = 0;
            y1 = 0;
            x2 = 0;
            y2 = 0;
            @(posedge clk);
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x1 = 16'h0000; y1 = 16'h0000;
            x2 = 16'h0005; y2 = 16'h0006;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(1'b1, 16'h0005, 16'h0006);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x1 = 16'h000A; y1 = 16'h000B;
            x2 = 16'h0000; y2 = 16'h0000;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(1'b1, 16'h000A, 16'h000B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x1 = 16'h0005; y1 = 16'h0006;
            x2 = 16'h0005; y2 = 16'h000B;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(1'b1, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x1 = 16'h0000; y1 = 16'h0001;
            x2 = 16'h0000; y2 = 16'h0001;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(1'b1, 16'h000D, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x1 = 16'h0000; y1 = 16'h0001;
            x2 = 16'h0001; y2 = 16'h0008;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(1'b1, 16'h000E, 16'h0003);
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
        input expected_valid_out;
        input [15:0] expected_x3;
        input [15:0] expected_y3;
        begin
            if (expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: valid_out=%b, x3=%h, y3=%h",
                         valid_out, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_out=%b, x3=%h, y3=%h",
                         expected_valid_out, expected_x3, expected_y3);
                $display("  Got:      valid_out=%b, x3=%h, y3=%h",
                         valid_out, x3, y3);
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
        $dumpvars(0,clk, rst, valid, x1, x2, y1, y2, valid_out, x3, y3);
    end

endmodule
