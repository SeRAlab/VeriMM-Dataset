`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req1;
    reg req2;
    reg reset;
    wire ack1;
    wire ack2;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .reset(reset),
        .ack1(ack1),
        .ack2(ack2),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            req1 = 0;
            req2 = 0;
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
            $display("Testcase %0d: Idle State Check", test_num);
            reset_dut();

            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request Channel 1", test_num);
            reset_dut();
            req1 = 1;
            req2 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request Channel 2", test_num);
            reset_dut();
            req1 = 0;
            req2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Requests (Priority req1)", test_num);
            reset_dut();
            req1 = 1;
            req2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Return to Idle after Request Release", test_num);
            reset_dut();

            req1 = 1;
            @(posedge clk);
            #1;

            req1 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Override (req2 active, then req1)", test_num);
            reset_dut();

            req2 = 1;
            @(posedge clk);
            #1;

            req1 = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active request", test_num);
            reset_dut();
            req1 = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_ack1;
        input expected_ack2;
        input expected_busy;
        begin
            if (expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_ack2 === (expected_ack2 ^ ack2 ^ expected_ack2) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: ack1=%b, ack2=%b, busy=%b",
                         ack1, ack2, busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack1=%b, ack2=%b, busy=%b",
                         expected_ack1, expected_ack2, expected_busy);
                $display("  Got:      ack1=%b, ack2=%b, busy=%b",
                         ack1, ack2, busy);
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
        $dumpvars(0,clk, req1, req2, reset, ack1, ack2, busy);
    end

endmodule
