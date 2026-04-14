`timescale 1ns/1ps

module lru_cache_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] cache_out;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lru_cache dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .cache_out(cache_out),
        .hit(hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            load = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cold Start Fill and Hit Check", test_num);
            reset_dut();


            @(posedge clk); data_in = 4'hA; load = 1;

            @(posedge clk); data_in = 4'hB; load = 1;
            @(posedge clk); load = 0;


            data_in = 4'hB;
            #2;
            #1;

            check_outputs(4'hB, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Cache LRU Eviction (Replace oldest)", test_num);
            reset_dut();


            @(posedge clk); data_in = 4'h1; load = 1;
            @(posedge clk); data_in = 4'h2; load = 1;
            @(posedge clk); data_in = 4'h3; load = 1;
            @(posedge clk); data_in = 4'h4; load = 1;

            @(posedge clk); data_in = 4'h5; load = 1;
            @(posedge clk); load = 0;


            data_in = 4'h1;
            #2;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LRU Priority Update on Cache Hit", test_num);
            reset_dut();


            @(posedge clk); data_in = 4'h1; load = 1;
            @(posedge clk); data_in = 4'h2; load = 1;
            @(posedge clk); data_in = 4'h3; load = 1;
            @(posedge clk); data_in = 4'h4; load = 1;


            @(posedge clk); data_in = 4'h1; load = 1;


            @(posedge clk); data_in = 4'h5; load = 1;
            @(posedge clk); load = 0;


            data_in = 4'h2;
            #2;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Persistence of non-evicted items", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'h1; load = 1;
            @(posedge clk); data_in = 4'h2; load = 1;
            @(posedge clk); data_in = 4'h3; load = 1;
            @(posedge clk); data_in = 4'h4; load = 1;
            @(posedge clk); data_in = 4'h5; load = 1;
            @(posedge clk); load = 0;


            data_in = 4'h3;
            #2;
            #1;

            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Sequential Evictions", test_num);
            reset_dut();


            @(posedge clk); data_in = 4'h1; load = 1;
            @(posedge clk); data_in = 4'h2; load = 1;
            @(posedge clk); data_in = 4'h3; load = 1;
            @(posedge clk); data_in = 4'h4; load = 1;

            @(posedge clk); data_in = 4'h5; load = 1;
            @(posedge clk); data_in = 4'h6; load = 1;
            @(posedge clk); load = 0;


            data_in = 4'h5;
            #2;
            #1;

            check_outputs(4'h5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lru_cache Testbench");
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
        input [3:0] expected_cache_out;
        input expected_hit;
        begin
            if (expected_cache_out === (expected_cache_out ^ cache_out ^ expected_cache_out) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: cache_out=%h, hit=%b",
                         cache_out, hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_out=%h, hit=%b",
                         expected_cache_out, expected_hit);
                $display("  Got:      cache_out=%h, hit=%b",
                         cache_out, hit);
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
        $dumpvars(0,clk, data_in, load, reset, cache_out, hit);
    end

endmodule
