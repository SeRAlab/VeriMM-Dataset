`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_ch1;
    reg enable_ch2;
    reg reset;
    reg start_ch1;
    reg start_ch2;
    wire done_ch1;
    wire done_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable_ch1(enable_ch1),
        .enable_ch2(enable_ch2),
        .reset(reset),
        .start_ch1(start_ch1),
        .start_ch2(start_ch2),
        .done_ch1(done_ch1),
        .done_ch2(done_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable_ch1 = 0;
            enable_ch2 = 0;
            start_ch1 = 0;
            start_ch2 = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            enable_ch1 = 1;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;


            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Single Transfer", test_num);
            reset_dut();

            enable_ch2 = 1;
            @(posedge clk);
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;


            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual Channel Simultaneous Transfer", test_num);
            reset_dut();

            enable_ch1 = 1;
            enable_ch2 = 1;
            @(posedge clk);
            start_ch1 = 1;
            start_ch2 = 1;
            @(posedge clk);
            start_ch1 = 0;
            start_ch2 = 0;


            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start CH1 without Enable (Should stay Idle)", test_num);
            reset_dut();

            enable_ch1 = 0;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start CH2 without Enable (Should stay Idle)", test_num);
            reset_dut();

            enable_ch2 = 0;
            @(posedge clk);
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Triggered Mid-transfer", test_num);
            reset_dut();

            enable_ch1 = 1;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;

            repeat (2) @(posedge clk);
            reset = 1;
            repeat (1) @(posedge clk);
            reset = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Channel Transfers", test_num);
            reset_dut();


            enable_ch1 = 1;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;
            repeat (5) @(posedge clk);


            enable_ch2 = 1;
            @(posedge clk);
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
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
        input expected_done_ch1;
        input expected_done_ch2;
        begin
            if (expected_done_ch1 === (expected_done_ch1 ^ done_ch1 ^ expected_done_ch1) &&
                expected_done_ch2 === (expected_done_ch2 ^ done_ch2 ^ expected_done_ch2)) begin
                $display("PASS");
                $display("  Outputs: done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_ch1=%b, done_ch2=%b",
                         expected_done_ch1, expected_done_ch2);
                $display("  Got:      done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
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
        $dumpvars(0,clk, enable_ch1, enable_ch2, reset, start_ch1, start_ch2, done_ch1, done_ch2);
    end

endmodule
