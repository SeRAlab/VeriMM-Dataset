`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] req;
    reg rst;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .en(en),
        .req(req),
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
        en = 0;
        req = 4'b0000;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: System Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Enable Low", test_num);
        reset_dut();
        en = 0;
        req = 4'b1111;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Single Request - Req 0", test_num);
        reset_dut();
        en = 1;
        req = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Single Request - Req 3", test_num);
        reset_dut();
        en = 1;
        req = 4'b1000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Multiple Requests - 0 wins over 1", test_num);
        reset_dut();
        en = 1;
        req = 4'b0011;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multiple Requests - 1 wins over 2", test_num);
        reset_dut();
        en = 1;
        req = 4'b0110;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiple Requests - 2 wins over 3", test_num);
        reset_dut();
        en = 1;
        req = 4'b1100;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: All Requests Active - 0 wins", test_num);
        reset_dut();
        en = 1;
        req = 4'b1111;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Scattered Requests - 1 wins over 3", test_num);
        reset_dut();
        en = 1;
        req = 4'b1010;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Toggle Enable mid-request", test_num);
        reset_dut();
        en = 1;
        req = 4'b0100;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0100);


        en = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0000);
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
        $dumpvars(0,clk, en, req, rst, grant);
    end

endmodule
