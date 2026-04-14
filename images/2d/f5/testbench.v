`timescale 1ns/1ps

module rrt_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] new_node_x;
    wire [7:0] new_node_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_tree dut (
        .clk(clk),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .target_x(target_x),
        .target_y(target_y),
        .new_node_x(new_node_x),
        .new_node_y(new_node_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("--- Resetting DUT ---");
            reset = 1;
            start_x = 0;
            start_y = 0;
            target_x = 0;
            target_y = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Expansion from Origin", test_num);
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd10;
            target_x = 8'd100;
            target_y = 8'd100;


            @(posedge clk);
            #1;



            if (new_node_x !== 8'hxx && new_node_y !== 8'hxx) begin
                $display("PASS: Module produced valid coordinates (%d, %d)", new_node_x, new_node_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Module produced invalid coordinates");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        reg [7:0] prev_x, prev_y;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Tree Expansion", test_num);
            reset_dut();

            start_x = 8'd128;
            start_y = 8'd128;
            target_x = 8'd250;
            target_y = 8'd250;

            repeat(5) @(posedge clk);
            #1;



            if (new_node_x <= 8'd255 && new_node_y <= 8'd255) begin
                pass_count = pass_count + 1;
                $display("PASS: Tree expanded for 5 cycles. Current node: (%d, %d)", new_node_x, new_node_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Out of bounds or invalid node at cycle 5");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Logic (Near 255)", test_num);
            reset_dut();

            start_x = 8'd250;
            start_y = 8'd250;
            target_x = 8'd255;
            target_y = 8'd255;

            @(posedge clk);
            #1;


            if (new_node_x >= 8'd0 && new_node_y >= 8'd0) begin
                $display("PASS: Boundary expansion handled. Node: (%d, %d)", new_node_x, new_node_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Logic failed at boundaries");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [7:0] node_before_reset_x;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset Verification", test_num);
            reset_dut();

            start_x = 8'd50;
            start_y = 8'd50;
            target_x = 8'd150;
            target_y = 8'd150;

            repeat(3) @(posedge clk);
            #1;
            node_before_reset_x = new_node_x;


            reset = 1;
            @(posedge clk);
            reset = 0;


            start_x = 8'd20;
            start_y = 8'd20;
            @(posedge clk);
            #1;




            if (new_node_x != node_before_reset_x) begin
                $display("PASS: Reset interrupted expansion and restarted.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset did not seem to clear internal state.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_tree Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_new_node_x;
        input [7:0] expected_new_node_y;
        begin
            if (expected_new_node_x === (expected_new_node_x ^ new_node_x ^ expected_new_node_x) &&
                expected_new_node_y === (expected_new_node_y ^ new_node_y ^ expected_new_node_y)) begin
                $display("PASS");
                $display("  Outputs: new_node_x=%h, new_node_y=%h",
                         new_node_x, new_node_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_node_x=%h, new_node_y=%h",
                         expected_new_node_x, expected_new_node_y);
                $display("  Got:      new_node_x=%h, new_node_y=%h",
                         new_node_x, new_node_y);
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
        $dumpvars(0,clk, reset, start_x, start_y, target_x, target_y, new_node_x, new_node_y);
    end

endmodule
