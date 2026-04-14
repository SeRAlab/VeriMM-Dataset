`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg [7:0] distance;
    reg reset;
    wire [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .direction(direction),
        .distance(distance),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 0;
            distance = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moving North", test_num);
            reset_dut();
            direction = 2'd0;
            distance = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moving East", test_num);
            reset_dut();
            direction = 2'd1;
            distance = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moving South", test_num);
            reset_dut();
            direction = 2'd2;
            distance = 8'd25;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd0, 16'hffe7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moving West", test_num);
            reset_dut();
            direction = 2'd3;
            distance = 8'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hfff6, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Square Path (N->E->S->W)", test_num);
            reset_dut();


            direction = 2'd0; distance = 8'd10;
            @(posedge clk); #1;


            direction = 2'd1; distance = 8'd10;
            @(posedge clk); #1;


            direction = 2'd2; distance = 8'd10;
            @(posedge clk); #1;


            direction = 2'd3; distance = 8'd10;
            @(posedge clk); #1;


            #1;



            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moving to (15, 15)", test_num);
            reset_dut();

            direction = 2'd0; distance = 8'd15;
            @(posedge clk); #1;

            direction = 2'd1; distance = 8'd15;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd15, 16'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max single step (255)", test_num);
            reset_dut();

            direction = 2'd1; distance = 8'hFF;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd255, 16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero distance check", test_num);
            reset_dut();

            direction = 2'd0; distance = 8'd0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd0, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_x;
        input [15:0] expected_y;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h",
                         expected_x, expected_y);
                $display("  Got:      x=%h, y=%h",
                         x, y);
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
        $dumpvars(0,clk, direction, distance, reset, x, y);
    end

endmodule
