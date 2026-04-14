`timescale 1ns/1ps

module DFS_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] start_node;
    wire [4:0] current_node;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS dut (
        .clk(clk),
        .rst(rst),
        .start_node(start_node),
        .current_node(current_node),
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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start at leaf node 31", test_num);
            start_node = 5'd31;
            reset_dut();


            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'd31, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start at node 15 (Single child subtree)", test_num);
            start_node = 5'd15;
            reset_dut();

            repeat (40) begin
                if (done) break;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'd31, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start at node 14 (Subtree 14, 29, 30)", test_num);
            start_node = 5'd14;
            reset_dut();

            repeat (40) begin
                if (done) break;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start at Root (Full tree traversal)", test_num);
            start_node = 5'd0;
            reset_dut();


            repeat (200) begin
                if (done) break;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFS Testbench");
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
        input [4:0] expected_current_node;
        input expected_done;
        begin
            if (expected_current_node === (expected_current_node ^ current_node ^ expected_current_node) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_node=%h, done=%b",
                         current_node, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_node=%h, done=%b",
                         expected_current_node, expected_done);
                $display("  Got:      current_node=%h, done=%b",
                         current_node, done);
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
        $dumpvars(0,clk, rst, start_node, current_node, done);
    end

endmodule
