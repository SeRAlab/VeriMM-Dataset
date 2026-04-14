`timescale 1ns/1ps

module RRT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] step_size;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] tree_x;
    wire [7:0] tree_y;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT dut (
        .clk(clk),
        .rst(rst),
        .step_size(step_size),
        .target_x(target_x),
        .target_y(target_y),
        .tree_x(tree_x),
        .tree_y(tree_y),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            step_size = 0;
            target_x = 0;
            target_y = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Growth", test_num);
            reset_dut();

            step_size = 8'd10;
            target_x = 8'd50;
            target_y = 8'd0;

            @(posedge clk);

            wait(valid == 1);


            #1;



            check_outputs(8'd10, 8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Growth", test_num);
            reset_dut();

            step_size = 8'd15;
            target_x = 8'd0;
            target_y = 8'd100;

            @(posedge clk);
            wait(valid == 1);


            #1;



            check_outputs(8'd0, 8'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Growth", test_num);
            reset_dut();

            step_size = 8'd20;
            target_x = 8'd40;
            target_y = 8'd40;

            @(posedge clk);
            wait(valid == 1);




            #1;





            check_outputs(8'd20, 8'd20, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target within Step Size", test_num);
            reset_dut();

            step_size = 8'd50;
            target_x = 8'd5;
            target_y = 8'd10;

            @(posedge clk);
            wait(valid == 1);


            #1;



            check_outputs(8'd5, 8'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Step Size", test_num);
            reset_dut();

            step_size = 8'd0;
            target_x = 8'd100;
            target_y = 8'd100;

            @(posedge clk);
            #20;


            #1;



            check_outputs(8'd0, 8'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT Testbench");
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
        input [7:0] expected_tree_x;
        input [7:0] expected_tree_y;
        input expected_valid;
        begin
            if (expected_tree_x === (expected_tree_x ^ tree_x ^ expected_tree_x) &&
                expected_tree_y === (expected_tree_y ^ tree_y ^ expected_tree_y) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: tree_x=%h, tree_y=%h, valid=%b",
                         tree_x, tree_y, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tree_x=%h, tree_y=%h, valid=%b",
                         expected_tree_x, expected_tree_y, expected_valid);
                $display("  Got:      tree_x=%h, tree_y=%h, valid=%b",
                         tree_x, tree_y, valid);
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
        $dumpvars(0,clk, rst, step_size, target_x, target_y, tree_x, tree_y, valid);
    end

endmodule
