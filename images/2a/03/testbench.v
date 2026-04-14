`timescale 1ns/1ps

module robot_slam_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    reg start;
    wire [1:0] state;
    wire [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_slam dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
        .start(start),
        .state(state),
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
            rst = 1;
            start = 0;
            direction = 2'b00;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Move Up", test_num);
            reset_dut();

            start = 1;
            direction = 2'b00;
            @(posedge clk);
            #1;
            start = 0;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 4'd0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Move Right", test_num);
            reset_dut();

            start = 1;
            direction = 2'b11;
            @(posedge clk);
            #1;
            start = 0;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 4'd1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Move Right then Up", test_num);
            reset_dut();


            start = 1; direction = 2'b11;
            @(posedge clk); #1; start = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;


            start = 1; direction = 2'b00;
            @(posedge clk); #1; start = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;


            #1;



            check_outputs(2'b00, 4'd1, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Move Up then Down", test_num);
            reset_dut();


            start = 1; direction = 2'b00;
            @(posedge clk); #1; start = 0;
            repeat(2) @(posedge clk); #1;


            start = 1; direction = 2'b01;
            @(posedge clk); #1; start = 0;
            repeat(2) @(posedge clk); #1;


            #1;



            check_outputs(2'b00, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No start signal check", test_num);
            reset_dut();

            start = 0;
            direction = 2'b11;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 4'd0, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_slam Testbench");
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
        input [1:0] expected_state;
        input [3:0] expected_x;
        input [3:0] expected_y;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: state=%h, x=%h, y=%h",
                         state, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, x=%h, y=%h",
                         expected_state, expected_x, expected_y);
                $display("  Got:      state=%h, x=%h, y=%h",
                         state, x, y);
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
        $dumpvars(0,clk, direction, rst, start, state, x, y);
    end

endmodule
