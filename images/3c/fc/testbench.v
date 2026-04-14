`timescale 1ns/1ps

module rrt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_x;
    reg [3:0] current_y;
    reg reset;
    reg [3:0] target_x;
    reg [3:0] target_y;
    wire [3:0] next_x;
    wire [3:0] next_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_controller dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .reset(reset),
        .target_x(target_x),
        .target_y(target_y),
        .next_x(next_x),
        .next_y(next_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_x = 0;
            current_y = 0;
            target_x = 0;
            target_y = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Positive X movement (0,0) -> (5,0)", test_num);
            reset_dut();
            current_x = 4'd0;
            current_y = 4'd0;
            target_x  = 4'd5;
            target_y  = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive Y movement (2,2) -> (2,10)", test_num);
            reset_dut();
            current_x = 4'd2;
            current_y = 4'd2;
            target_x  = 4'd2;
            target_y  = 4'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Diagonal movement (5,5) -> (8,8)", test_num);
            reset_dut();
            current_x = 4'd5;
            current_y = 4'd5;
            target_x  = 4'd8;
            target_y  = 4'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd6, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative movement (10,10) -> (5,5)", test_num);
            reset_dut();
            current_x = 4'd10;
            current_y = 4'd10;
            target_x  = 4'd5;
            target_y  = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd9, 4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Already at target (7,7) -> (7,7)", test_num);
            reset_dut();
            current_x = 4'd7;
            current_y = 4'd7;
            target_x  = 4'd7;
            target_y  = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7, 4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary movement (14,14) -> (15,15)", test_num);
            reset_dut();
            current_x = 4'd14;
            current_y = 4'd14;
            target_x  = 4'd15;
            target_y  = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mix movement (2,10) -> (4,8)", test_num);
            reset_dut();
            current_x = 4'd2;
            current_y = 4'd10;
            target_x  = 4'd4;
            target_y  = 4'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd3, 4'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_next_x;
        input [3:0] expected_next_y;
        begin
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x) &&
                expected_next_y === (expected_next_y ^ next_y ^ expected_next_y)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h, next_y=%h",
                         next_x, next_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h, next_y=%h",
                         expected_next_x, expected_next_y);
                $display("  Got:      next_x=%h, next_y=%h",
                         next_x, next_y);
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
        $dumpvars(0,clk, current_x, current_y, reset, target_x, target_y, next_x, next_y);
    end

endmodule
