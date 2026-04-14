`timescale 1ns/1ps

module RRT_Node_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] distance_threshold;
    reg [7:0] last_x;
    reg [7:0] last_y;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg reset;
    wire [7:0] new_x;
    wire [7:0] new_y;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Node dut (
        .clk(clk),
        .distance_threshold(distance_threshold),
        .last_x(last_x),
        .last_y(last_y),
        .random_x(random_x),
        .random_y(random_y),
        .reset(reset),
        .new_x(new_x),
        .new_y(new_y),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            distance_threshold = 0;
            last_x = 0;
            last_y = 0;
            random_x = 0;
            random_y = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point within threshold", test_num);
            reset_dut();


            distance_threshold = 8'd20;
            last_x = 8'd10;
            last_y = 8'd15;
            random_x = 8'd20;
            random_y = 8'd20;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd20, 8'd20, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point outside threshold", test_num);
            reset_dut();


            distance_threshold = 8'd50;
            last_x = 8'd10;
            last_y = 8'd10;
            random_x = 8'd100;
            random_y = 8'd100;

            @(posedge clk);
            #2;





            #1;






            check_outputs(new_x, new_y, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point exactly at threshold", test_num);
            reset_dut();


            distance_threshold = 8'd10;
            last_x = 8'd10;
            last_y = 8'd10;
            random_x = 8'd15;
            random_y = 8'd15;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd15, 8'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point with negative differences", test_num);
            reset_dut();


            distance_threshold = 8'd20;
            last_x = 8'd50;
            last_y = 8'd50;
            random_x = 8'd40;
            random_y = 8'd45;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd40, 8'd45, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero distance check", test_num);
            reset_dut();

            distance_threshold = 8'd5;
            last_x = 8'd100;
            last_y = 8'd100;
            random_x = 8'd100;
            random_y = 8'd100;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd100, 8'd100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Distance just above threshold", test_num);
            reset_dut();


            distance_threshold = 8'd10;
            last_x = 8'd10;
            last_y = 8'd10;
            random_x = 8'd15;
            random_y = 8'd16;

            @(posedge clk);
            #2;


            #1;



            check_outputs(new_x, new_y, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Node Testbench");
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
        input expected_valid;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h, valid=%b",
                         new_x, new_y, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h, valid=%b",
                         expected_new_x, expected_new_y, expected_valid);
                $display("  Got:      new_x=%h, new_y=%h, valid=%b",
                         new_x, new_y, valid);
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
        $dumpvars(0,clk, distance_threshold, last_x, last_y, random_x, random_y, reset, new_x, new_y, valid);
    end

endmodule
