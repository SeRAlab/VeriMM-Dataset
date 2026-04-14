`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] index;
    reg rst;
    wire [7:0] current_value;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .clk(clk),
        .index(index),
        .rst(rst),
        .current_value(current_value),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            index = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-node Traversal (0 -> 1 -> 2)", test_num);
            reset_dut();

            index = 4'h0;



            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any




            #1;





            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single-node Traversal (Index 3)", test_num);
            reset_dut();

            index = 4'h3;

            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any


            #1;



            check_outputs(8'h44, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two-node Traversal (4 -> 5)", test_num);
            reset_dut();

            index = 4'h4;

            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any


            #1;



            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Immediate NULL pointer start", test_num);
            reset_dut();

            index = 4'hF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
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
        input [7:0] expected_current_value;
        input expected_done;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, done=%b",
                         current_value, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, done=%b",
                         expected_current_value, expected_done);
                $display("  Got:      current_value=%h, done=%b",
                         current_value, done);
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
        $dumpvars(0,clk, index, rst, current_value, done);
    end

endmodule
