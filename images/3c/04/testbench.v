`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel1_done;
    reg channel2_done;
    reg clk;
    reg reset;
    reg start_channel1;
    reg start_channel2;
    wire active_channel1;
    wire active_channel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel1_done(channel1_done),
        .channel2_done(channel2_done),
        .clk(clk),
        .reset(reset),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .active_channel1(active_channel1),
        .active_channel2(active_channel2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_channel1 = 0;
            start_channel2 = 0;
            channel1_done = 0;
            channel2_done = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Activation", test_num);
            reset_dut();
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Completion", test_num);
            reset_dut();
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            repeat(2) @(posedge clk);
            channel1_done = 1;
            @(posedge clk);
            channel1_done = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Activation", test_num);
            reset_dut();
            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: CH2 Wait State while CH1 Active", test_num);
            reset_dut();

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;

            repeat(2) @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: CH2 Transition after CH1 Done", test_num);
            reset_dut();

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;

            repeat(2) @(posedge clk);
            channel1_done = 1;
            @(posedge clk);
            channel1_done = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Start (Priority Check)", test_num);
            reset_dut();
            @(posedge clk);
            start_channel1 = 1;
            start_channel2 = 1;
            @(posedge clk);
            start_channel1 = 0;
            start_channel2 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Completion", test_num);
            reset_dut();
            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;
            repeat(2) @(posedge clk);
            channel2_done = 1;
            @(posedge clk);
            channel2_done = 0;
            @(posedge clk);

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
        input expected_active_channel1;
        input expected_active_channel2;
        begin
            if (expected_active_channel1 === (expected_active_channel1 ^ active_channel1 ^ expected_active_channel1) &&
                expected_active_channel2 === (expected_active_channel2 ^ active_channel2 ^ expected_active_channel2)) begin
                $display("PASS");
                $display("  Outputs: active_channel1=%b, active_channel2=%b",
                         active_channel1, active_channel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel1=%b, active_channel2=%b",
                         expected_active_channel1, expected_active_channel2);
                $display("  Got:      active_channel1=%b, active_channel2=%b",
                         active_channel1, active_channel2);
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
        $dumpvars(0,channel1_done, channel2_done, clk, reset, start_channel1, start_channel2, active_channel1, active_channel2);
    end

endmodule
