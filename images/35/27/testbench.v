`timescale 1ns/1ps

module bfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_tree dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .output_data(output_data)
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
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic BFS Traversal", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            while (!done) begin
                @(posedge clk);
            end



            #1;




            check_outputs(1'b1, 8'h07);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Consecutive BFS Traversal", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);


            repeat(5) @(posedge clk);


            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Re-trigger Start Signal", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(10) @(posedge clk);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_tree Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [7:0] expected_output_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_data=%h",
                         done, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_data=%h",
                         expected_done, expected_output_data);
                $display("  Got:      done=%b, output_data=%h",
                         done, output_data);
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
        $dumpvars(0,clk, reset, start, done, output_data);
    end

endmodule
