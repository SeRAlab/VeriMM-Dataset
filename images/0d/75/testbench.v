`timescale 1ns/1ps

module rrt_node_manager_tb;

    // Testbench signals (sequential circuit)
    reg add_node;
    reg clk;
    reg [7:0] new_x;
    reg [7:0] new_y;
    reg reset;
    reg traverse;
    wire [7:0] current_x;
    wire [7:0] current_y;
    wire [7:0] node_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node_manager dut (
        .add_node(add_node),
        .clk(clk),
        .new_x(new_x),
        .new_y(new_y),
        .reset(reset),
        .traverse(traverse),
        .current_x(current_x),
        .current_y(current_y),
        .node_count(node_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            add_node = 0;
            traverse = 0;
            new_x = 0;
            new_y = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning testcase%03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning testcase%03d: Add Single Node", test_num);
            reset_dut();


            new_x = 8'h0F;
            new_y = 8'h19;
            add_node = 1;
            @(posedge clk);
            add_node = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h0F, 8'h19, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning testcase%03d: Add Multiple Nodes", test_num);
            reset_dut();


            new_x = 8'h0A; new_y = 8'h0B; add_node = 1; @(posedge clk);

            new_x = 8'h14; new_y = 8'h1E; add_node = 1; @(posedge clk);

            new_x = 8'h64; new_y = 8'hC8; add_node = 1; @(posedge clk);

            add_node = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h64, 8'hC8, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning testcase%03d: Traversal Check", test_num);
            reset_dut();


            new_x = 8'd10; new_y = 8'd10; add_node = 1; @(posedge clk);

            new_x = 8'd20; new_y = 8'd20; add_node = 1; @(posedge clk);
            add_node = 0; @(posedge clk);



            traverse = 1;
            @(posedge clk);
            traverse = 0;
            @(posedge clk);


            #1;



            check_outputs(8'd10, 8'd10, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning testcase%03d: Mixed Add and Traverse", test_num);
            reset_dut();


            new_x = 8'hAA; new_y = 8'hBB; add_node = 1; @(posedge clk);
            add_node = 0; @(posedge clk);


            traverse = 1; @(posedge clk);
            traverse = 0; @(posedge clk);


            new_x = 8'hCC; new_y = 8'hDD; add_node = 1; @(posedge clk);
            add_node = 0; @(posedge clk);


            #1;



            check_outputs(8'hCC, 8'hDD, 8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning testcase%03d: Boundary Values", test_num);
            reset_dut();

            new_x = 8'hFF; new_y = 8'hFF; add_node = 1;
            @(posedge clk);
            add_node = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 8'hFF, 8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_node_manager Testbench");
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
        input [7:0] expected_current_x;
        input [7:0] expected_current_y;
        input [7:0] expected_node_count;
        begin
            if (expected_current_x === (expected_current_x ^ current_x ^ expected_current_x) &&
                expected_current_y === (expected_current_y ^ current_y ^ expected_current_y) &&
                expected_node_count === (expected_node_count ^ node_count ^ expected_node_count)) begin
                $display("PASS");
                $display("  Outputs: current_x=%h, current_y=%h, node_count=%h",
                         current_x, current_y, node_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_x=%h, current_y=%h, node_count=%h",
                         expected_current_x, expected_current_y, expected_node_count);
                $display("  Got:      current_x=%h, current_y=%h, node_count=%h",
                         current_x, current_y, node_count);
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
        $dumpvars(0,add_node, clk, new_x, new_y, reset, traverse, current_x, current_y, node_count);
    end

endmodule
