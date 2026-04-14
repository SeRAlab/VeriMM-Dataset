`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
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
        test_num = test_num + 1;
        $display("Test Case %03d: No requests active", test_num);
        reset_dut();
        req0 = 0; req1 = 0; req2 = 0; req3 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Only req0 active", test_num);
        reset_dut();
        req0 = 1; req1 = 0; req2 = 0; req3 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Only req1 active", test_num);
        reset_dut();
        req0 = 0; req1 = 1; req2 = 0; req3 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Only req2 active", test_num);
        reset_dut();
        req0 = 0; req1 = 0; req2 = 1; req3 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Only req3 active", test_num);
        reset_dut();
        req0 = 0; req1 = 0; req2 = 0; req3 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Contention req0 and req1", test_num);
        reset_dut();
        req0 = 1; req1 = 1; req2 = 0; req3 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Contention req1 and req3", test_num);
        reset_dut();
        req0 = 0; req1 = 1; req2 = 0; req3 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Contention req2 and req3", test_num);
        reset_dut();
        req0 = 0; req1 = 0; req2 = 1; req3 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All requests active", test_num);
        reset_dut();
        req0 = 1; req1 = 1; req2 = 1; req3 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: req1, req2, req3 active", test_num);
        reset_dut();
        req0 = 0; req1 = 1; req2 = 1; req3 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        input [3:0] expected_grant;
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
