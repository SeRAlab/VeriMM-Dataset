`timescale 1ns/1ps

module rrt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg condition;
    reg reset;
    reg start;
    wire new_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_controller dut (
        .clk(clk),
        .condition(condition),
        .reset(reset),
        .start(start),
        .new_node(new_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            condition = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Node Addition (Start=1, Cond=1)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            condition = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Condition Not Met (Start=1, Cond=0)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            condition = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Start Not High (Start=0, Cond=1)", test_num);
            reset_dut();
            @(negedge clk);
            start = 0;
            condition = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: One Clock Cycle Pulse Verification", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            condition = 1;
            @(posedge clk);
            @(negedge clk);



            start = 0;
            condition = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset Overrides Start", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            condition = 1;
            reset = 1;
            @(posedge clk);
            #1;
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
        $display("rrt_controller Testbench");
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
        input expected_new_node;
        begin
            if (expected_new_node === (expected_new_node ^ new_node ^ expected_new_node)) begin
                $display("PASS");
                $display("  Outputs: new_node=%b",
                         new_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_node=%b",
                         expected_new_node);
                $display("  Got:      new_node=%b",
                         new_node);
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
        $dumpvars(0,clk, condition, reset, start, new_node);
    end

endmodule
