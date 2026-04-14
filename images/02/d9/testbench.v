`timescale 1ns/1ps

module rrt_node_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] existing_node_x;
    reg [7:0] existing_node_y;
    reg [7:0] new_node_x;
    reg [7:0] new_node_y;
    reg rst;
    wire node_added;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node_addition dut (
        .clk(clk),
        .existing_node_x(existing_node_x),
        .existing_node_y(existing_node_y),
        .new_node_x(new_node_x),
        .new_node_y(new_node_y),
        .rst(rst),
        .node_added(node_added)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            existing_node_x = 0;
            existing_node_y = 0;
            new_node_x = 0;
            new_node_y = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical coordinates", test_num);
            reset_dut();
            existing_node_x = 8'd50;
            existing_node_y = 8'd50;
            new_node_x = 8'd50;
            new_node_y = 8'd50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small distance (offset 5, 5)", test_num);
            reset_dut();
            existing_node_x = 8'd10;
            existing_node_y = 8'd10;
            new_node_x = 8'd15;
            new_node_y = 8'd15;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large distance (offset 200, 200)", test_num);
            reset_dut();
            existing_node_x = 8'd0;
            existing_node_y = 8'd0;
            new_node_x = 8'd200;
            new_node_y = 8'd200;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moderate distance (offset 30, 40)", test_num);
            reset_dut();
            existing_node_x = 8'd100;
            existing_node_y = 8'd100;
            new_node_x = 8'd130;
            new_node_y = 8'd140;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values check", test_num);
            reset_dut();
            existing_node_x = 8'd255;
            existing_node_y = 8'd255;
            new_node_x = 8'd250;
            new_node_y = 8'd250;
            repeat(2) @(posedge clk);
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
        $display("rrt_node_addition Testbench");
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
        input expected_node_added;
        begin
            if (expected_node_added === (expected_node_added ^ node_added ^ expected_node_added)) begin
                $display("PASS");
                $display("  Outputs: node_added=%b",
                         node_added);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: node_added=%b",
                         expected_node_added);
                $display("  Got:      node_added=%b",
                         node_added);
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
        $dumpvars(0,clk, existing_node_x, existing_node_y, new_node_x, new_node_y, rst, node_added);
    end

endmodule
