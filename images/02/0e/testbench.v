`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    wire [1:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .rst(rst),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            req3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Requestor 0 only", test_num);
            reset_dut();
            req0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Requestor 2 only", test_num);
            reset_dut();
            req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple requests (0 and 1), check rotation", test_num);
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sparse requests (0 and 3), skip 1 and 2", test_num);
            reset_dut();
            req0 = 1;
            req3 = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Wrap around from 3 to 0", test_num);
            reset_dut();
            req0 = 1;
            req3 = 1;

            req0 = 0; req3 = 1;
            @(posedge clk);

            req0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All active, check index 2 after 2 cycles", test_num);
            reset_dut();
            req0 = 1; req1 = 1; req2 = 1; req3 = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Requestor drops out", test_num);
            reset_dut();
            req0 = 1; req1 = 1; req2 = 1;
            @(posedge clk);
            req1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("round_robin_arbiter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
        $dumpvars(0,clk, req0, req1, req2, req3, rst, grant);
    end

endmodule
