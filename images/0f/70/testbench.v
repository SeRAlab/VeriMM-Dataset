`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg go_left;
    reg go_right;
    reg [7:0] node_value;
    reg reset;
    wire done;
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .go_left(go_left),
        .go_right(go_right),
        .node_value(node_value),
        .reset(reset),
        .done(done),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            go_left = 0;
            go_right = 0;
            node_value = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Visit Root Node", test_num);
            reset_dut();

            node_value = 8'hA1;
            go_left = 0;
            go_right = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Traverse to Left Child", test_num);
            reset_dut();


            node_value = 8'h10; go_left = 0; go_right = 0;
            @(posedge clk);

            node_value = 8'h20; go_left = 1; go_right = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Traverse to Right Child", test_num);
            reset_dut();


            node_value = 8'h10; go_left = 0; go_right = 0;
            @(posedge clk);

            node_value = 8'h30; go_left = 0; go_right = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Deep Left Traversal", test_num);
            reset_dut();


            node_value = 8'h05; go_left = 0; go_right = 0;
            @(posedge clk);

            node_value = 8'h0A; go_left = 1; go_right = 0;
            @(posedge clk);

            node_value = 8'h0F; go_left = 1; go_right = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Root to Left then Right", test_num);
            reset_dut();


            node_value = 8'h01; go_left = 0; go_right = 0;
            @(posedge clk);

            node_value = 8'h02; go_left = 1; go_right = 0;
            @(posedge clk);

            node_value = 8'h03; go_left = 0; go_right = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 8'h03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_tree Testbench");
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
        input expected_done;
        input [7:0] expected_output_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_value=%h",
                         done, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_value=%h",
                         expected_done, expected_output_value);
                $display("  Got:      done=%b, output_value=%h",
                         done, output_value);
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
        $dumpvars(0,clk, go_left, go_right, node_value, reset, done, output_value);
    end

endmodule
