`timescale 1ns/1ps

module rrt_path_planner_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg reset;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] new_x;
    wire [7:0] new_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_path_planner dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .reset(reset),
        .target_x(target_x),
        .target_y(target_y),
        .new_x(new_x),
        .new_y(new_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_x = 8'd0;
            current_y = 8'd0;
            target_x = 8'd0;
            target_y = 8'd0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Direction (10,10) -> (50,50)", test_num);
            reset_dut();
            current_x = 8'd10;
            current_y = 8'd10;
            target_x = 8'd50;
            target_y = 8'd50;
            @(posedge clk);
            #2;



            #1;




            check_outputs(new_x, new_y);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Direction (100,100) -> (20,20)", test_num);
            reset_dut();
            current_x = 8'd100;
            current_y = 8'd100;
            target_x = 8'd20;
            target_y = 8'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(new_x, new_y);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target equals Current (75,75)", test_num);
            reset_dut();
            current_x = 8'd75;
            current_y = 8'd75;
            target_x = 8'd75;
            target_y = 8'd75;
            @(posedge clk);
            #2;

            #1;


            check_outputs(new_x, new_y);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pure Horizontal Movement (10,50) -> (100,50)", test_num);
            reset_dut();
            current_x = 8'd10;
            current_y = 8'd50;
            target_x = 8'd100;
            target_y = 8'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(new_x, new_y);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Max Values (250,250) -> (255,255)", test_num);
            reset_dut();
            current_x = 8'd250;
            current_y = 8'd250;
            target_x = 8'd255;
            target_y = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(new_x, new_y);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Origin (5,5) -> (0,0)", test_num);
            reset_dut();
            current_x = 8'd5;
            current_y = 8'd5;
            target_x = 8'd0;
            target_y = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(new_x, new_y);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_path_planner Testbench");
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
        input [7:0] expected_new_x;
        input [7:0] expected_new_y;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h",
                         new_x, new_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h",
                         expected_new_x, expected_new_y);
                $display("  Got:      new_x=%h, new_y=%h",
                         new_x, new_y);
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
        $dumpvars(0,clk, current_x, current_y, reset, target_x, target_y, new_x, new_y);
    end

endmodule
