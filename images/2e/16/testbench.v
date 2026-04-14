`timescale 1ns/1ps

module bfs_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] current_node;
    reg reset;
    wire [2:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_fsm dut (
        .clk(clk),
        .current_node(current_node),
        .reset(reset),
        .next_node(next_node)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_node = 3'b000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            current_node = 3'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_node = 3'd1;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_node = 3'd2;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_node = 3'd3;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_node = 3'd4;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_fsm Testbench");
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
        input [2:0] expected_next_node;
        begin
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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
        $dumpvars(0,clk, current_node, reset, next_node);
    end

endmodule
