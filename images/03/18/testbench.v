`timescale 1ns/1ps

module rrt_path_finder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg reset;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire valid_path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_path_finder dut (
        .clk(clk),
        .random_x(random_x),
        .random_y(random_y),
        .reset(reset),
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
            reset = 1;
            random_x = 0;
            random_y = 0;
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
            reset_dut();

            random_x = 8'd50;
            random_y = 8'd50;
            target_x = 8'd50;
            target_y = 8'd50;

            @(posedge clk);
            #2;

            test_num = test_num + 1;
            $display("Testcase %0d: Exact Match (50,50) to (50,50)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            random_x = 8'd10;
            random_y = 8'd10;
            target_x = 8'd200;
            target_y = 8'd200;

            @(posedge clk);
            #2;

            test_num = test_num + 1;
            $display("Testcase %0d: Far Distance (10,10) to (200,200)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            random_x = 8'd100;
            random_y = 8'd100;
            target_x = 8'd102;
            target_y = 8'd101;

            @(posedge clk);
            #2;

            test_num = test_num + 1;
            $display("Testcase %0d: Close Proximity (100,100) to (102,101)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            random_x = 8'd0;
            random_y = 8'd0;
            target_x = 8'd255;
            target_y = 8'd255;

            @(posedge clk);
            #2;

            test_num = test_num + 1;
            $display("Testcase %0d: Corner to Corner (0,0) to (255,255)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            random_x = 8'd128;
            random_y = 8'd128;
            target_x = 8'd128;
            target_y = 8'd131;

            @(posedge clk);
            #2;

            test_num = test_num + 1;
            $display("Testcase %0d: Small Y-Axis Delta (128,128) to (128,131)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_path_finder Testbench");
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
        input expected_valid_path;
        begin
            if (expected_valid_path === (expected_valid_path ^ valid_path ^ expected_valid_path)) begin
                $display("PASS");
                $display("  Outputs: valid_path=%b",
                         valid_path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_path=%b",
                         expected_valid_path);
                $display("  Got:      valid_path=%b",
                         valid_path);
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
        $dumpvars(0,clk, random_x, random_y, reset, target_x, target_y, valid_path);
    end

endmodule
