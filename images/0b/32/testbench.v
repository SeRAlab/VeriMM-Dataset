`timescale 1ns/1ps

module DFS_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [3:0] path;
    wire [3:0] visited;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .path(path),
        .visited(visited)
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
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard DFS Execution", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (30) @(posedge clk);


            #1;



            check_outputs(4'h2, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during Search", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (5) @(posedge clk);


            reset = 1;
            #20;
            reset = 0;
            #10;


            #1;



            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle State Check", test_num);
            reset_dut();

            repeat (10) @(posedge clk);


            #1;



            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive Starts", test_num);
            reset_dut();


            @(posedge clk);
            start = 1; @(posedge clk); start = 0;
            repeat (30) @(posedge clk);


            reset_dut();
            @(posedge clk);
            start = 1; @(posedge clk); start = 0;
            repeat (30) @(posedge clk);

            #1;


            check_outputs(4'h2, 4'hF);
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
        input [3:0] expected_path;
        input [3:0] expected_visited;
        begin
            if (expected_path === (expected_path ^ path ^ expected_path) &&
                expected_visited === (expected_visited ^ visited ^ expected_visited)) begin
                $display("PASS");
                $display("  Outputs: path=%h, visited=%h",
                         path, visited);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path=%h, visited=%h",
                         expected_path, expected_visited);
                $display("  Got:      path=%h, visited=%h",
                         path, visited);
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
        $dumpvars(0,clk, reset, start, path, visited);
    end

endmodule
