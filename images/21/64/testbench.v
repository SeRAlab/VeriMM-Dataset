`timescale 1ns/1ps

module cache_replacement_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cache_in;
    reg cache_req;
    reg clk;
    reg policy;
    reg reset;
    wire cache_hit;
    wire [7:0] cache_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_replacement dut (
        .cache_in(cache_in),
        .cache_req(cache_req),
        .clk(clk),
        .policy(policy),
        .reset(reset),
        .cache_hit(cache_hit),
        .cache_out(cache_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cache_in = 8'h0;
            cache_req = 0;
            policy = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Basic Write/Read Hit", test_num);
            reset_dut();

            policy = 1;


            cache_req = 0; cache_in = 8'hAA; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'hBB; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'hAA; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Capacity Eviction", test_num);
            reset_dut();

            policy = 1;


            cache_req = 0; cache_in = 8'h11; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h22; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h33; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h44; @(posedge clk); #1;


            cache_req = 0; cache_in = 8'h55; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'h11; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 8'hxx);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Basic Hit", test_num);
            reset_dut();

            policy = 0;


            cache_req = 0; cache_in = 8'hA5; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'hA5; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Replacement Logic", test_num);
            reset_dut();

            policy = 0;


            cache_req = 0; cache_in = 8'h11; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h22; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h33; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h44; @(posedge clk); #1;



            cache_req = 1; cache_in = 8'h11; @(posedge clk); #1;


            cache_req = 0; cache_in = 8'h55; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'h22; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 8'hxx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU MRU Preservation", test_num);
            reset_dut();

            policy = 0;

            cache_req = 0; cache_in = 8'h11; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h22; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h33; @(posedge clk); #1;
            cache_req = 0; cache_in = 8'h44; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'h11; @(posedge clk); #1;


            cache_req = 0; cache_in = 8'h99; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'h11; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Validation", test_num);
            reset_dut();


            cache_req = 0; cache_in = 8'hFF; @(posedge clk); #1;


            reset = 1; @(posedge clk); reset = 0; @(posedge clk); #1;


            cache_req = 1; cache_in = 8'hFF; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 8'hxx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_replacement Testbench");
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
        input expected_cache_hit;
        input [7:0] expected_cache_out;
        begin
            if (expected_cache_hit === (expected_cache_hit ^ cache_hit ^ expected_cache_hit) &&
                expected_cache_out === (expected_cache_out ^ cache_out ^ expected_cache_out)) begin
                $display("PASS");
                $display("  Outputs: cache_hit=%b, cache_out=%h",
                         cache_hit, cache_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_hit=%b, cache_out=%h",
                         expected_cache_hit, expected_cache_out);
                $display("  Got:      cache_hit=%b, cache_out=%h",
                         cache_hit, cache_out);
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
        $dumpvars(0,cache_in, cache_req, clk, policy, reset, cache_hit, cache_out);
    end

endmodule
