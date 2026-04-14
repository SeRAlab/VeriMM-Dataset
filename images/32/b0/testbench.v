`timescale 1ns/1ps

module rrt_pathfinding_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] end_x;
    reg [7:0] end_y;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire [7:0] current_x;
    wire [7:0] current_y;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_pathfinding dut (
        .clk(clk),
        .end_x(end_x),
        .end_y(end_y),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .current_x(current_x),
        .current_y(current_y),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_x = 0;
            start_y = 0;
            end_x = 0;
            end_y = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Start equals End", test_num);
            reset_dut();
            start_x = 8'd50;
            start_y = 8'd50;
            end_x = 8'd50;
            end_y = 8'd50;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'd50, 8'd50, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Horizontal Path", test_num);
            reset_dut();
            start_x = 8'd10;
            start_y = 8'd10;
            end_x = 8'd30;
            end_y = 8'd10;


            fork : wait_or_timeout_2
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(500) @(posedge clk);
                end
            join_any
            disable wait_or_timeout_2;

            #1;


            check_outputs(8'd30, 8'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Vertical Path", test_num);
            reset_dut();
            start_x = 8'd100;
            start_y = 8'd50;
            end_x = 8'd100;
            end_y = 8'd80;

            fork : wait_or_timeout_3
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(500) @(posedge clk);
                end
            join_any
            disable wait_or_timeout_3;

            #1;


            check_outputs(8'd100, 8'd80, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Diagonal Path", test_num);
            reset_dut();
            start_x = 8'd20;
            start_y = 8'd20;
            end_x = 8'd40;
            end_y = 8'd40;

            fork : wait_or_timeout_4
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(1000) @(posedge clk);
                end
            join_any
            disable wait_or_timeout_4;

            #1;


            check_outputs(8'd40, 8'd40, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Long Distance Path", test_num);
            reset_dut();
            start_x = 8'd0;
            start_y = 8'd0;
            end_x = 8'd150;
            end_y = 8'd150;


            fork : wait_or_timeout_5
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(5000) @(posedge clk);
                end
            join_any
            disable wait_or_timeout_5;

            #1;


            check_outputs(8'd150, 8'd150, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_pathfinding Testbench");
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
        input [7:0] expected_current_x;
        input [7:0] expected_current_y;
        input expected_done;
        begin
            if (expected_current_x === (expected_current_x ^ current_x ^ expected_current_x) &&
                expected_current_y === (expected_current_y ^ current_y ^ expected_current_y) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_x=%h, current_y=%h, done=%b",
                         current_x, current_y, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_x=%h, current_y=%h, done=%b",
                         expected_current_x, expected_current_y, expected_done);
                $display("  Got:      current_x=%h, current_y=%h, done=%b",
                         current_x, current_y, done);
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
        $dumpvars(0,clk, end_x, end_y, reset, start_x, start_y, current_x, current_y, done);
    end

endmodule
