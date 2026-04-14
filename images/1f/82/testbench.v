`timescale 1ns/1ps

module slam_update_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dx;
    reg [7:0] dy;
    reg reset;
    wire [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_update dut (
        .clk(clk),
        .dx(dx),
        .dy(dy),
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
            dx = 8'h00;
            dy = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Single-Step Movement", test_num);
            reset_dut();

            dx = 8'h05;
            dy = 8'h0A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h05, 8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Steps Accumulation", test_num);
            reset_dut();

            dx = 8'h01; dy = 8'h02; @(posedge clk);
            dx = 8'h03; dy = 8'h04; @(posedge clk);
            dx = 8'h10; dy = 8'h20; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h14, 8'h26);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Movement Internal State Check", test_num);
            reset_dut();

            dx = 8'hFF; dy = 8'hEE; @(posedge clk);
            dx = 8'h00; dy = 8'h00; @(posedge clk);
            dx = 8'h00; dy = 8'h00; @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'hEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 8-bit Overflow Wrap-around", test_num);
            reset_dut();

            dx = 8'hFF; dy = 8'h80; @(posedge clk);
            dx = 8'h02; dy = 8'h80; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Mid-way through movement", test_num);
            reset_dut();

            dx = 8'h20; dy = 8'h20; @(posedge clk);
            dx = 8'h20; dy = 8'h20; @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            dx = 8'h05; dy = 8'h05; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h05, 8'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum 8-bit increments", test_num);
            reset_dut();

            dx = 8'hFF; dy = 8'hFF; @(posedge clk);
            dx = 8'hFF; dy = 8'hFF; @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFE, 8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_update Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_x;
        input [7:0] expected_y;
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
        $dumpvars(0,clk, dx, dy, reset, x, y);
    end

endmodule
