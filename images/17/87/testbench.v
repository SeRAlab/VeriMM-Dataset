`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x;
    reg [7:0] y;
    wire [9:0] count;
    wire inside_circle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .clk(clk),
        .x(x),
        .y(y),
        .count(count),
        .inside_circle(inside_circle)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            x = 0;
            y = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All points inside circle", test_num);
            reset_dut();

            x = 8'd0;   y = 8'd0;   @(posedge clk);
            x = 8'd100; y = 8'd100; @(posedge clk);
            x = 8'd128; y = 8'd128; @(posedge clk);
            x = 8'd255; y = 8'd0;   @(posedge clk);
            x = 8'd0;   y = 8'd255; @(posedge clk);

            #1;
            #1;

            check_outputs(10'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All points outside circle", test_num);
            reset_dut();

            x = 8'd200; y = 8'd200; @(posedge clk);
            x = 8'd255; y = 8'd255; @(posedge clk);
            x = 8'd190; y = 8'd180; @(posedge clk);
            x = 8'd255; y = 8'd50;  @(posedge clk);
            x = 8'd150; y = 8'd210; @(posedge clk);

            #1;
            #1;

            check_outputs(10'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed points", test_num);
            reset_dut();

            x = 8'd10;  y = 8'd10;  @(posedge clk);
            x = 8'd240; y = 8'd240; @(posedge clk);
            x = 8'd128; y = 8'd128; @(posedge clk);
            x = 8'd200; y = 8'd200; @(posedge clk);
            x = 8'd50;  y = 8'd50;  @(posedge clk);

            #1;
            #1;

            check_outputs(10'd3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary conditions", test_num);
            reset_dut();


            x = 8'd181; y = 8'd181; @(posedge clk);

            x = 8'd181; y = 8'd182; @(posedge clk);

            x = 8'd255; y = 8'd10;  @(posedge clk);

            x = 8'd10;  y = 8'd255; @(posedge clk);

            x = 8'd200; y = 8'd160; @(posedge clk);

            #1;
            #1;

            check_outputs(10'd3, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Corner points", test_num);
            reset_dut();

            x = 8'd254; y = 8'd1;   @(posedge clk);
            x = 8'd1;   y = 8'd254; @(posedge clk);
            x = 8'd255; y = 8'd255; @(posedge clk);
            x = 8'd0;   y = 8'd0;   @(posedge clk);
            x = 8'd181; y = 8'd181; @(posedge clk);

            #1;
            #1;

            check_outputs(10'd4, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_pi Testbench");
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
        input [9:0] expected_count;
        input expected_inside_circle;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_inside_circle === (expected_inside_circle ^ inside_circle ^ expected_inside_circle)) begin
                $display("PASS");
                $display("  Outputs: count=%h, inside_circle=%b",
                         count, inside_circle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, inside_circle=%b",
                         expected_count, expected_inside_circle);
                $display("  Got:      count=%h, inside_circle=%b",
                         count, inside_circle);
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
        $dumpvars(0,clk, x, y, count, inside_circle);
    end

endmodule
