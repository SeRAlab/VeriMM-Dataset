`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg empty;
    reg ge2_free;
    reg ge3_free;
    reg [1:0] input_tm_cnt;
    wire [4:0] fifo_cnt_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .empty(empty),
        .ge2_free(ge2_free),
        .ge3_free(ge3_free),
        .input_tm_cnt(input_tm_cnt),
        .fifo_cnt_inc(fifo_cnt_inc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: FIFO Empty, Count = 0", test_num);
        empty = 1'b1;
        ge2_free = 1'b0;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b00;
        #1;

        check_outputs(5'd0);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: FIFO Empty, Count = 3 (Priority Check)", test_num);
        empty = 1'b1;
        ge2_free = 1'b1;
        ge3_free = 1'b1;
        input_tm_cnt = 2'b11;
        #1;

        check_outputs(5'd3);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: FIFO Not Empty, ge3 Free, Count = 3", test_num);
        empty = 1'b0;
        ge2_free = 1'b0;
        ge3_free = 1'b1;
        input_tm_cnt = 2'b11;
        #1;

        check_outputs(5'd2);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: FIFO Not Empty, ge3 Free, Count = 2 (ge3 logic requires count=3)", test_num);
        empty = 1'b0;
        ge2_free = 1'b0;
        ge3_free = 1'b1;
        input_tm_cnt = 2'b10;
        #1;

        check_outputs(5'd0);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: FIFO Not Empty, ge2 Free, Count = 2", test_num);
        empty = 1'b0;
        ge2_free = 1'b1;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b10;
        #1;

        check_outputs(5'd1);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: FIFO Not Empty, ge2 Free, Count = 1 (ge2 logic requires count>=2)", test_num);
        empty = 1'b0;
        ge2_free = 1'b1;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b01;
        #1;

        check_outputs(5'd0);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: FIFO Not Empty, Resources Not Free, Count = 1", test_num);
        empty = 1'b0;
        ge2_free = 1'b0;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b01;
        #1;

        check_outputs(5'd0);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: FIFO Not Empty, Resources Not Free, Count = 3", test_num);
        empty = 1'b0;
        ge2_free = 1'b0;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b11;
        #1;

        check_outputs(5'd0);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: FIFO Not Empty, Count = 0 (Otherwise Case)", test_num);
        empty = 1'b0;
        ge2_free = 1'b0;
        ge3_free = 1'b0;
        input_tm_cnt = 2'b00;
        #1;

        check_outputs(5'b11111);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: ge3 and ge2 both free, Count = 3 (Priority Check)", test_num);
        empty = 1'b0;
        ge2_free = 1'b1;
        ge3_free = 1'b1;
        input_tm_cnt = 2'b11;
        #1;

        check_outputs(5'd2);
    end
    endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %03d: ge3 and ge2 both free, Count = 2 (Priority Check)", test_num);
        empty = 1'b0;
        ge2_free = 1'b1;
        ge3_free = 1'b1;
        input_tm_cnt = 2'b10;
        #1;

        check_outputs(5'd1);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [4:0] expected_fifo_cnt_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifo_cnt_inc === (expected_fifo_cnt_inc ^ fifo_cnt_inc ^ expected_fifo_cnt_inc)) begin
                $display("PASS");
                $display("  Outputs: fifo_cnt_inc=%h",
                         fifo_cnt_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_cnt_inc=%h",
                         expected_fifo_cnt_inc);
                $display("  Got:      fifo_cnt_inc=%h",
                         fifo_cnt_inc);
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
