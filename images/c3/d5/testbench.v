`timescale 1ns/1ps

module fifo_controller_tb;

    // Testbench signals (combinational circuit)
    reg empty;
    reg free2;
    reg free3;
    reg [1:0] tm_count;
    wire [4:0] fifocount_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_controller dut (
        .empty(empty),
        .free2(free2),
        .free3(free3),
        .tm_count(tm_count),
        .fifocount_inc(fifocount_inc)
    );
    task testcase001;

    begin
        $display("Test 1: Empty FIFO, tm_count = 0");
        test_num = 1;
        empty = 1; free2 = 0; free3 = 0; tm_count = 2'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Test 2: Empty FIFO, tm_count = 3");
        test_num = 2;
        empty = 1; free2 = 0; free3 = 0; tm_count = 2'd3;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase003;

    begin
        $display("Test 3: Free3 High, tm_count = 3");
        test_num = 3;
        empty = 0; free3 = 1; free2 = 0; tm_count = 2'd3;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase004;

    begin
        $display("Test 4: Free3 priority over Free2, tm_count = 3");
        test_num = 4;
        empty = 0; free3 = 1; free2 = 1; tm_count = 2'd3;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        $display("Test 5: Free2 High, tm_count = 2");
        test_num = 5;
        empty = 0; free3 = 0; free2 = 1; tm_count = 2'd2;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase006;

    begin
        $display("Test 6: Free2 High, tm_count = 3");
        test_num = 6;
        empty = 0; free3 = 0; free2 = 1; tm_count = 2'd3;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase007;

    begin
        $display("Test 7: tm_count >= 1 (tm=1), no free flags");
        test_num = 7;
        empty = 0; free3 = 0; free2 = 0; tm_count = 2'd1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase008;

    begin
        $display("Test 8: tm_count >= 1 (tm=2), no free flags");
        test_num = 8;
        empty = 0; free3 = 0; free2 = 0; tm_count = 2'd2;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase009;

    begin
        $display("Test 9: tm_count >= 1 (tm=3), no free flags");
        test_num = 9;
        empty = 0; free3 = 0; free2 = 0; tm_count = 2'd3;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase010;

    begin
        $display("Test 10: Otherwise condition (empty=0, tm_count=0)");
        test_num = 10;
        empty = 0; free3 = 0; free2 = 0; tm_count = 2'd0;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase011;

    begin
        $display("Test 11: Priority check - empty has highest priority");
        test_num = 11;
        empty = 1; free3 = 1; free2 = 1; tm_count = 2'd3;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase012;

    begin
        $display("Test 12: Free3 high but tm_count != 3 (tm=2), falls to Free2 rule");
        test_num = 12;
        empty = 0; free3 = 1; free2 = 1; tm_count = 2'd2;
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
        $display("fifo_controller Testbench");
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
        testcase012();
        
        
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
        input [4:0] expected_fifocount_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifocount_inc === (expected_fifocount_inc ^ fifocount_inc ^ expected_fifocount_inc)) begin
                $display("PASS");
                $display("  Outputs: fifocount_inc=%h",
                         fifocount_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifocount_inc=%h",
                         expected_fifocount_inc);
                $display("  Got:      fifocount_inc=%h",
                         fifocount_inc);
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
