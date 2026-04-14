`timescale 1ns/1ps

module robot_slam_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg reset;
    wire [1:0] pos_x;
    wire [1:0] pos_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_slam dut (
        .clk(clk),
        .direction(direction),
        .reset(reset),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 2'b00;
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
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Move to (1,1)", test_num);
            reset_dut();

            direction = 2'b11;
            @(posedge clk); #1;

            direction = 2'b00;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move to Boundary (3,2)", test_num);
            reset_dut();


            direction = 2'b11;
            repeat(3) @(posedge clk); #1;


            direction = 2'b00;
            repeat(2) @(posedge clk); #1;

            #1;


            check_outputs(2'b11, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Wrap-around from (0,0)", test_num);
            reset_dut();

            direction = 2'b10;
            @(posedge clk); #1;

            direction = 2'b01;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Path to (2,1)", test_num);
            reset_dut();










            direction = 2'b11; repeat(2) @(posedge clk); #1;
            direction = 2'b00; @(posedge clk); #1;
            direction = 2'b11; @(posedge clk); #1;
            direction = 2'b01; @(posedge clk); #1;
            direction = 2'b10; @(posedge clk); #1;
            direction = 2'b00; @(posedge clk); #1;

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Wrap-around from (3,3)", test_num);
            reset_dut();


            direction = 2'b11; repeat(3) @(posedge clk); #1;
            direction = 2'b00; repeat(3) @(posedge clk); #1;


            direction = 2'b11; @(posedge clk); #1;

            direction = 2'b00; @(posedge clk); #1;

            #1;


            check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_pos_x;
        input [1:0] expected_pos_y;
        begin
            if (expected_pos_x === (expected_pos_x ^ pos_x ^ expected_pos_x) &&
                expected_pos_y === (expected_pos_y ^ pos_y ^ expected_pos_y)) begin
                $display("PASS");
                $display("  Outputs: pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_x=%h, pos_y=%h",
                         expected_pos_x, expected_pos_y);
                $display("  Got:      pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
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
        $dumpvars(0,clk, direction, reset, pos_x, pos_y);
    end

endmodule
