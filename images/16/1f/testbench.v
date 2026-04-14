`timescale 1ns/1ps

module elliptic_curve_add_tb;

    // Testbench signals (sequential circuit)
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
    elliptic_curve_add dut (
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
            $display("\nTestcase %0d: P + Point-at-Infinity", test_num);
            reset_dut();


            x1 = 32'd2;
            y1 = 32'd3;
            x2 = 32'hFFFFFFFF;
            y2 = 32'hFFFFFFFF;


            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd2, 32'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point-at-Infinity + P", test_num);
            reset_dut();


            x1 = 32'hFFFFFFFF;
            y1 = 32'hFFFFFFFF;
            x2 = 32'd0;
            y2 = 32'd1;

            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd0, 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point Addition with Inverse (Result = Infinity)", test_num);
            reset_dut();



            x1 = 32'd2;
            y1 = 32'd3;
            x2 = 32'd2;
            y2 = 32'hFFFFFFFD;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: General Point Addition", test_num);
            reset_dut();

            x1 = 32'd2;
            y1 = 32'd3;
            x2 = 32'd0;
            y2 = 32'd1;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point Doubling", test_num);
            reset_dut();

            x1 = 32'd0;
            y1 = 32'd1;
            x2 = 32'd0;
            y2 = 32'd1;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'd0, 32'hFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("elliptic_curve_add Testbench");
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
        $dumpvars(0,clk, rst, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
