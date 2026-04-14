`timescale 1ns/1ps

module cache_lru_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] accessed_idx;
    reg [3:0] valid_bits;
    wire [1:0] replace_idx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_lru dut (
        .accessed_idx(accessed_idx),
        .valid_bits(valid_bits),
        .replace_idx(replace_idx)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset - Expect index 0 (first invalid)", test_num);
            rst_n = 0;
            accessed_idx = 0;
            valid_bits = 4'b0000;
            @(posedge clk);
            #1 rst_n = 1;
            valid_bits = 4'b0000;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Slot 0 filled - Expect index 1", test_num);
            rst_n = 0; @(posedge clk); rst_n = 1;
            valid_bits = 4'b0001;
            accessed_idx = 2'd0;
            @(posedge clk);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All valid, sequence 0->1->2->3 - Expect 0 as LRU", test_num);
            rst_n = 0; @(posedge clk); rst_n = 1;
            valid_bits = 4'b1111;


            accessed_idx = 2'd0; @(posedge clk);
            accessed_idx = 2'd1; @(posedge clk);
            accessed_idx = 2'd2; @(posedge clk);
            accessed_idx = 2'd3; @(posedge clk);


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequence 0->1->2->3 then access 0 - Expect 1 as LRU", test_num);
            rst_n = 0; @(posedge clk); rst_n = 1;
            valid_bits = 4'b1111;

            accessed_idx = 2'd0; @(posedge clk);
            accessed_idx = 2'd1; @(posedge clk);
            accessed_idx = 2'd2; @(posedge clk);
            accessed_idx = 2'd3; @(posedge clk);
            accessed_idx = 2'd0; @(posedge clk);


            #1;



            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequence 0->1->2->3 then access 2 - Expect 0 as LRU", test_num);
            rst_n = 0; @(posedge clk); rst_n = 1;
            valid_bits = 4'b1111;

            accessed_idx = 2'd0; @(posedge clk);
            accessed_idx = 2'd1; @(posedge clk);
            accessed_idx = 2'd2; @(posedge clk);
            accessed_idx = 2'd3; @(posedge clk);
            accessed_idx = 2'd2; @(posedge clk);


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequence 3->2->1->0 - Expect 3 as LRU", test_num);
            rst_n = 0; @(posedge clk); rst_n = 1;
            valid_bits = 4'b1111;

            accessed_idx = 2'd3; @(posedge clk);
            accessed_idx = 2'd2; @(posedge clk);
            accessed_idx = 2'd1; @(posedge clk);
            accessed_idx = 2'd0; @(posedge clk);

            #1;


            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_lru Testbench");
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
        input [1:0] expected_replace_idx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_replace_idx === (expected_replace_idx ^ replace_idx ^ expected_replace_idx)) begin
                $display("PASS");
                $display("  Outputs: replace_idx=%h",
                         replace_idx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replace_idx=%h",
                         expected_replace_idx);
                $display("  Got:      replace_idx=%h",
                         replace_idx);
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

endmodule
