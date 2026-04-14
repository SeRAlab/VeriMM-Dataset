`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    wire busy;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable(enable),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .rst(rst),
        .busy(busy),
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
            enable = 0;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            req3 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: System Idle State", test_num);
            reset_dut();
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Request Channel 0", test_num);
            reset_dut();
            enable = 1;
            req0 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Request Channel 2", test_num);
            reset_dut();
            enable = 1;
            req2 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Request with Enable Low", test_num);
            reset_dut();
            enable = 0;
            req1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Round-Robin Transition (0 -> 1)", test_num);
            reset_dut();
            enable = 1;
            req0 = 1;
            req1 = 1;


            @(posedge clk);
            #1;



            req0 = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Round-Robin Full Cycle (3 -> 0)", test_num);
            reset_dut();
            enable = 1;


            req3 = 1;
            repeat(2) @(posedge clk);


            req3 = 0;
            req0 = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Busy De-assertion", test_num);
            reset_dut();
            enable = 1;
            req1 = 1;
            @(posedge clk);
            req1 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_busy;
        input expected_grant;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, grant=%b",
                         busy, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, grant=%b",
                         expected_busy, expected_grant);
                $display("  Got:      busy=%b, grant=%b",
                         busy, grant);
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
        $dumpvars(0,clk, enable, req0, req1, req2, req3, rst, busy, grant);
    end

endmodule
