`timescale 1ns/1ps

module dfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    reg [3:0] start_node;
    wire done;
    wire [3:0] visited_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .start_node(start_node),
        .done(done),
        .visited_node(visited_node)
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
            start_node = 4'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS Starting from Node 0", test_num);
            reset_dut();

            start_node = 4'd0;
            start = 1;
            @(posedge clk);
            start = 0;



            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(200) @(posedge clk);
                end
            join_any
            disable timeout_block;




            #1;





            check_outputs(1'b1, visited_node);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DFS Starting from Node 5", test_num);
            reset_dut();

            start_node = 4'd5;
            start = 1;
            @(posedge clk);
            start = 0;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(200) @(posedge clk);
                end
            join_any
            disable timeout_block;

            #1;


            check_outputs(1'b1, visited_node);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive DFS Runs", test_num);


            reset_dut();
            start_node = 4'd2;
            start = 1; @(posedge clk); start = 0;
            wait(done == 1'b1);
            repeat(2) @(posedge clk);


            start_node = 4'd1;
            start = 1; @(posedge clk); start = 0;

            fork : timeout_block
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(200) @(posedge clk);
                end
            join_any
            disable timeout_block;

            #1;


            check_outputs(1'b1, visited_node);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Operation", test_num);
            reset_dut();

            start_node = 4'd0;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(5) @(posedge clk);
            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;


            if (done == 1'b0) begin
                $display("PASS: Circuit reset correctly during operation.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Done signal high after reset.");
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
        $display("dfs Testbench");
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
        input expected_done;
        input [3:0] expected_visited_node;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_visited_node === (expected_visited_node ^ visited_node ^ expected_visited_node)) begin
                $display("PASS");
                $display("  Outputs: done=%b, visited_node=%h",
                         done, visited_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, visited_node=%h",
                         expected_done, expected_visited_node);
                $display("  Got:      done=%b, visited_node=%h",
                         done, visited_node);
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
        $dumpvars(0,clk, reset, start, start_node, done, visited_node);
    end

endmodule
