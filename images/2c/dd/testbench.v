`timescale 1ns/1ps

module cache_replacement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] policy_sel;
    reg [3:0] request;
    reg reset;
    wire [1:0] replace_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_replacement dut (
        .clk(clk),
        .policy_sel(policy_sel),
        .request(request),
        .reset(reset),
        .replace_index(replace_index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            policy_sel = 2'b00;
            request = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Basic Sequence", test_num);
            reset_dut();
            policy_sel = 2'b00;


            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Basic Sequence", test_num);
            reset_dut();
            policy_sel = 2'b01;

            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Hit Persistence", test_num);
            reset_dut();
            policy_sel = 2'b00;

            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;


            request = 4'd0; @(posedge clk); #1;

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Recency Update", test_num);
            reset_dut();
            policy_sel = 2'b01;

            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;


            request = 4'd0; @(posedge clk); #1;

            #1;


            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LRU Complex Pattern", test_num);
            reset_dut();
            policy_sel = 2'b01;

            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd0; @(posedge clk); #1;

            #1;


            check_outputs(2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Policy Switch FIFO to LRU", test_num);
            reset_dut();


            policy_sel = 2'b00;
            request = 4'd0; @(posedge clk); #1;
            request = 4'd1; @(posedge clk); #1;
            request = 4'd2; @(posedge clk); #1;
            request = 4'd3; @(posedge clk); #1;


            policy_sel = 2'b01;
            request = 4'd0; @(posedge clk); #1;


            #1;



            check_outputs(2'd1);
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
        input [1:0] expected_replace_index;
        begin
            if (expected_replace_index === (expected_replace_index ^ replace_index ^ expected_replace_index)) begin
                $display("PASS");
                $display("  Outputs: replace_index=%h",
                         replace_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replace_index=%h",
                         expected_replace_index);
                $display("  Got:      replace_index=%h",
                         replace_index);
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
        $dumpvars(0,clk, policy_sel, request, reset, replace_index);
    end

endmodule
