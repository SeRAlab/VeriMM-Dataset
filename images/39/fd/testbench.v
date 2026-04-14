`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg Req0;
    reg Req1;
    reg Req2;
    reg Req3;
    reg clk;
    reg rst;
    wire [3:0] Grant;
    wire Valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .Req0(Req0),
        .Req1(Req1),
        .Req2(Req2),
        .Req3(Req3),
        .clk(clk),
        .rst(rst),
        .Grant(Grant),
        .Valid(Valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        Req0 = 0;
        Req1 = 0;
        Req2 = 0;
        Req3 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Highest priority Req0 active", test_num);
        reset_dut();
        Req0 = 1; Req1 = 0; Req2 = 0; Req3 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Req1 active, Req0 inactive", test_num);
        reset_dut();
        Req0 = 0; Req1 = 1; Req2 = 0; Req3 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Req2 active, Req0/1 inactive", test_num);
        reset_dut();
        Req0 = 0; Req1 = 0; Req2 = 1; Req3 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0100, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Req3 active (lowest priority)", test_num);
        reset_dut();
        Req0 = 0; Req1 = 0; Req2 = 0; Req3 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All requests active (Req0 wins)", test_num);
        reset_dut();
        Req0 = 1; Req1 = 1; Req2 = 1; Req3 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Req1 and Req3 active (Req1 wins)", test_num);
        reset_dut();
        Req0 = 0; Req1 = 1; Req2 = 0; Req3 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: No requests active", test_num);
        reset_dut();
        Req0 = 0; Req1 = 0; Req2 = 0; Req3 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify output changes only on clock edge", test_num);
        reset_dut();
        Req0 = 0; Req1 = 1; Req2 = 0; Req3 = 0;
        #2;

        if (Valid === 0 && Grant === 4'b0000) begin
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010, 1'b1);
        end else begin
             $display("FAIL: Output changed asynchronously");
             fail_count = fail_count + 1;
        end
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
        input [3:0] expected_Grant;
        input expected_Valid;
        begin
            if (expected_Grant === (expected_Grant ^ Grant ^ expected_Grant) &&
                expected_Valid === (expected_Valid ^ Valid ^ expected_Valid)) begin
                $display("PASS");
                $display("  Outputs: Grant=%h, Valid=%b",
                         Grant, Valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Grant=%h, Valid=%b",
                         expected_Grant, expected_Valid);
                $display("  Got:      Grant=%h, Valid=%b",
                         Grant, Valid);
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
        $dumpvars(0,Req0, Req1, Req2, Req3, clk, rst, Grant, Valid);
    end

endmodule
