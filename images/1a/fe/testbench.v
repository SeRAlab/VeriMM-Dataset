`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg reset;
    wire gnt0;
    wire gnt1;
    wire gnt2;
    wire gnt3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .reset(reset),
        .gnt0(gnt0),
        .gnt1(gnt1),
        .gnt2(gnt2),
        .gnt3(gnt3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        req0 = 0;
        req1 = 0;
        req2 = 0;
        req3 = 0;
        ack = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Initial Reset State", test_num);
        reset_dut();
        #1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Request Channel 0", test_num);
        reset_dut();
        req0 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Request Channel 3", test_num);
        reset_dut();
        req3 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority Arbitration (Req1 vs Req2)", test_num);
        reset_dut();
        req1 = 1;
        req2 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Handshake Completion", test_num);
        reset_dut();
        req0 = 1;
        @(posedge clk);
        #1;
        ack = 1;
        @(posedge clk);
        req0 = 0;
        ack = 0;
        #1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Priority Transition", test_num);
        reset_dut();
        req1 = 1;
        req2 = 1;
        @(posedge clk);
        #1;
        ack = 1;
        @(posedge clk);
        #1;
        ack = 0;
        req1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Grant Stability without Ack", test_num);
        reset_dut();
        req2 = 1;
        @(posedge clk);
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Priority Override", test_num);
        reset_dut();
        req0 = 1;
        req1 = 1;
        req2 = 1;
        req3 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_gnt0;
        input expected_gnt1;
        input expected_gnt2;
        input expected_gnt3;
        begin
            if (expected_gnt0 === (expected_gnt0 ^ gnt0 ^ expected_gnt0) &&
                expected_gnt1 === (expected_gnt1 ^ gnt1 ^ expected_gnt1) &&
                expected_gnt2 === (expected_gnt2 ^ gnt2 ^ expected_gnt2) &&
                expected_gnt3 === (expected_gnt3 ^ gnt3 ^ expected_gnt3)) begin
                $display("PASS");
                $display("  Outputs: gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         gnt0, gnt1, gnt2, gnt3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         expected_gnt0, expected_gnt1, expected_gnt2, expected_gnt3);
                $display("  Got:      gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         gnt0, gnt1, gnt2, gnt3);
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
        $dumpvars(0,ack, clk, req0, req1, req2, req3, reset, gnt0, gnt1, gnt2, gnt3);
    end

endmodule
