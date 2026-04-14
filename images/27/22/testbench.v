`timescale 1ns/1ps

module rrt_motion_planning_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    wire [7:0] random_x;
    wire [7:0] random_y;
    wire [7:0] target_x;
    wire [7:0] target_y;
    wire valid_path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_motion_planning dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .random_x(random_x),
        .random_y(random_y),
        .target_x(target_x),
        .target_y(target_y),
        .valid_path(valid_path)
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
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Trigger Start and Check Random Point Sampling", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(5) @(posedge clk);




            #1;





            check_outputs(random_x, random_y, target_x, target_y, valid_path);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Longer execution for path discovery", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            repeat(200) @(posedge clk);



            #1;




            check_outputs(random_x, random_y, target_x, target_y, valid_path);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset mid-operation", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(20) @(posedge clk);


            rst = 1;
            #20;
            rst = 0;
            #10;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consecutive operation check", test_num);


            reset_dut();
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(50) @(posedge clk);


            start = 1;
            @(posedge clk);
            start = 0;
            repeat(50) @(posedge clk);


            #1;



            check_outputs(random_x, random_y, target_x, target_y, valid_path);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_motion_planning Testbench");
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
        input [7:0] expected_random_x;
        input [7:0] expected_random_y;
        input [7:0] expected_target_x;
        input [7:0] expected_target_y;
        input expected_valid_path;
        begin
            if (expected_random_x === (expected_random_x ^ random_x ^ expected_random_x) &&
                expected_random_y === (expected_random_y ^ random_y ^ expected_random_y) &&
                expected_target_x === (expected_target_x ^ target_x ^ expected_target_x) &&
                expected_target_y === (expected_target_y ^ target_y ^ expected_target_y) &&
                expected_valid_path === (expected_valid_path ^ valid_path ^ expected_valid_path)) begin
                $display("PASS");
                $display("  Outputs: random_x=%h, random_y=%h, target_x=%h, target_y=%h, valid_path=%b",
                         random_x, random_y, target_x, target_y, valid_path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_x=%h, random_y=%h, target_x=%h, target_y=%h, valid_path=%b",
                         expected_random_x, expected_random_y, expected_target_x, expected_target_y, expected_valid_path);
                $display("  Got:      random_x=%h, random_y=%h, target_x=%h, target_y=%h, valid_path=%b",
                         random_x, random_y, target_x, target_y, valid_path);
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
        $dumpvars(0,clk, rst, start, random_x, random_y, target_x, target_y, valid_path);
    end

endmodule
