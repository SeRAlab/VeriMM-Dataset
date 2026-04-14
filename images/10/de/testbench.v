`timescale 1ns/1ps

module rrt_path_planning_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max_iterations;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_path_planning dut (
        .clk(clk),
        .max_iterations(max_iterations),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .target_x(target_x),
        .target_y(target_y),
        .found(found)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_x = 8'h0;
            start_y = 8'h0;
            target_x = 8'h0;
            target_y = 8'h0;
            max_iterations = 8'h0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start point equals target point", test_num);
            reset_dut();
            start_x = 8'd100;
            start_y = 8'd100;
            target_x = 8'd100;
            target_y = 8'd100;
            max_iterations = 8'd10;


            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insufficient iterations for distant target", test_num);
            reset_dut();
            start_x = 8'd10;
            start_y = 8'd10;
            target_x = 8'd250;
            target_y = 8'd250;
            max_iterations = 8'd1;


            repeat (10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple reachability with high iteration count", test_num);
            reset_dut();
            start_x = 8'd10;
            start_y = 8'd10;
            target_x = 8'd30;
            target_y = 8'd30;
            max_iterations = 8'd255;


            repeat (300) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large distance reachability test", test_num);
            reset_dut();
            start_x = 8'd0;
            start_y = 8'd0;
            target_x = 8'd200;
            target_y = 8'd200;
            max_iterations = 8'd255;


            repeat (500) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            start_x = 8'd50;
            start_y = 8'd50;
            target_x = 8'd60;
            target_y = 8'd60;
            max_iterations = 8'd100;

            repeat (20) @(posedge clk);
            reset = 1;
            #20;
            reset = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_path_planning Testbench");
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
        input expected_found;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
        $dumpvars(0,clk, max_iterations, reset, start_x, start_y, target_x, target_y, found);
    end

endmodule
