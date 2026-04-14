`timescale 1ns/1ps

module random_sampler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x_range_max;
    reg [7:0] x_range_min;
    reg [7:0] y_range_max;
    reg [7:0] y_range_min;
    wire [7:0] x_coord;
    wire [7:0] y_coord;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    random_sampler dut (
        .clk(clk),
        .x_range_max(x_range_max),
        .x_range_min(x_range_min),
        .y_range_max(y_range_max),
        .y_range_min(y_range_min),
        .x_coord(x_coord),
        .y_coord(y_coord)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x_range_max <= 8'h0;
            x_range_min <= 8'h0;
            y_range_max <= 8'h0;
            y_range_min <= 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Deterministic Range (Min=Max)", test_num);
            reset_dut();
            x_range_min = 8'd50;
            x_range_max = 8'd50;
            y_range_min = 8'd120;
            y_range_max = 8'd120;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50, 8'd120);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small Range Validation", test_num);
            reset_dut();
            x_range_min = 8'd10;
            x_range_max = 8'd15;
            y_range_min = 8'd200;
            y_range_max = 8'd205;
            @(posedge clk);
            #2;

            if ((x_coord >= 10 && x_coord <= 15) && (y_coord >= 200 && y_coord <= 205))
                #1;

                check_outputs(x_coord, y_coord);
            else
                #1;

                check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Range Validation (0-255)", test_num);
            reset_dut();
            x_range_min = 8'd0;
            x_range_max = 8'd255;
            y_range_min = 8'd0;
            y_range_max = 8'd255;
            @(posedge clk);
            #2;

            if (x_coord <= 255 && y_coord <= 255)
                #1;

                check_outputs(x_coord, y_coord);
            else
                #1;

                check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Boundary Range", test_num);
            reset_dut();
            x_range_min = 8'd250;
            x_range_max = 8'd255;
            y_range_min = 8'd250;
            y_range_max = 8'd255;
            @(posedge clk);
            #2;
            if (x_coord >= 250 && x_coord <= 255 && y_coord >= 250 && y_coord <= 255)
                #1;

                check_outputs(x_coord, y_coord);
            else
                #1;

                check_outputs(8'd255, 8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-Range Offset", test_num);
            reset_dut();
            x_range_min = 8'd120;
            x_range_max = 8'd130;
            y_range_min = 8'd60;
            y_range_max = 8'd70;
            @(posedge clk);
            #2;
            if (x_coord >= 120 && x_coord <= 130 && y_coord >= 60 && y_coord <= 70)
                #1;

                check_outputs(x_coord, y_coord);
            else
                #1;

                check_outputs(8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("random_sampler Testbench");
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
        input [7:0] expected_x_coord;
        input [7:0] expected_y_coord;
        begin
            if (expected_x_coord === (expected_x_coord ^ x_coord ^ expected_x_coord) &&
                expected_y_coord === (expected_y_coord ^ y_coord ^ expected_y_coord)) begin
                $display("PASS");
                $display("  Outputs: x_coord=%h, y_coord=%h",
                         x_coord, y_coord);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_coord=%h, y_coord=%h",
                         expected_x_coord, expected_y_coord);
                $display("  Got:      x_coord=%h, y_coord=%h",
                         x_coord, y_coord);
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
        $dumpvars(0,clk, x_range_max, x_range_min, y_range_max, y_range_min, x_coord, y_coord);
    end

endmodule
