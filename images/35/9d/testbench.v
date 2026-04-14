`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg rst;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire valid;
    wire [31:0] x3;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .valid(valid),
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
            a = 0;
            b = 0;
            x1 = 0;
            y1 = 0;
            x2 = 0;
            y2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd2;
            b = 32'd2;
            x1 = 32'd3;
            y1 = 32'd1;
            x2 = 32'd3;
            y2 = 32'd1;

            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test %0d: Point Doubling (3,1) + (3,1) over F17", test_num);
            #1;

            check_outputs(1'b1, 32'd13, 32'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd2;
            b = 32'd2;
            x1 = 32'd3;
            y1 = 32'd1;
            x2 = 32'd5;
            y2 = 32'd1;

            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test %0d: Point Addition (3,1) + (5,1) over F17", test_num);
            #1;

            check_outputs(1'b1, 32'd9, 32'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd2;
            b = 32'd2;
            x1 = 32'd3;
            y1 = 32'd16;
            x2 = 32'd3;
            y2 = 32'd16;

            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test %0d: Point Doubling (3,16) + (3,16) over F17", test_num);
            #1;

            check_outputs(1'b1, 32'd13, 32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd2;
            b = 32'd2;
            x1 = 32'd5;
            y1 = 32'd16;
            x2 = 32'd3;
            y2 = 32'd1;

            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test %0d: Point Addition (5,16) + (3,1) over F17", test_num);
            #1;

            check_outputs(1'b1, 32'd10, 32'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'd1;
            b = 32'd1;
            x1 = 32'd0;
            y1 = 32'd1;
            x2 = 32'd0;
            y2 = 32'd1;

            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test %0d: Point Doubling (0,1) + (0,1) on y^2=x^3+x+1 over F17", test_num);
            #1;

            check_outputs(1'b1, 32'd13, 32'd1);
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
        input expected_valid;
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, x3=%h, y3=%h",
                         expected_valid, expected_x3, expected_y3);
                $display("  Got:      valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
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
        $dumpvars(0,a, b, clk, rst, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
