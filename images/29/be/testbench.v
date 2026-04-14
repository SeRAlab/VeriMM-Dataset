`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_chan1;
    reg enable_chan2;
    reg req_chan1;
    reg req_chan2;
    reg rst_n;
    wire done_chan1;
    wire done_chan2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable_chan1(enable_chan1),
        .enable_chan2(enable_chan2),
        .req_chan1(req_chan1),
        .req_chan2(req_chan2),
        .rst_n(rst_n),
        .done_chan1(done_chan1),
        .done_chan2(done_chan2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable_chan1 = 0;
            enable_chan2 = 0;
            req_chan1 = 0;
            req_chan2 = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Channel 1 Basic Transfer", test_num);
            reset_dut();

            enable_chan1 = 1;
            req_chan1 = 1;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Channel 2 Basic Transfer", test_num);
            reset_dut();

            enable_chan2 = 1;
            req_chan2 = 1;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Dual Channel Simultaneous Transfer", test_num);
            reset_dut();

            enable_chan1 = 1;
            req_chan1 = 1;
            enable_chan2 = 1;
            req_chan2 = 1;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Channel 1 Request while Disabled", test_num);
            reset_dut();

            enable_chan1 = 0;
            req_chan1 = 1;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Channel 2 Request while Disabled", test_num);
            reset_dut();

            enable_chan2 = 0;
            req_chan2 = 1;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Enable High without Request", test_num);
            reset_dut();

            enable_chan1 = 1;
            enable_chan2 = 1;
            req_chan1 = 0;
            req_chan2 = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Disable Channel Mid-Operation", test_num);
            reset_dut();

            enable_chan1 = 1;
            req_chan1 = 1;
            repeat(2) @(posedge clk);
            enable_chan1 = 0;

            repeat(10) @(posedge clk);


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
        input expected_done_chan1;
        input expected_done_chan2;
        begin
            if (expected_done_chan1 === (expected_done_chan1 ^ done_chan1 ^ expected_done_chan1) &&
                expected_done_chan2 === (expected_done_chan2 ^ done_chan2 ^ expected_done_chan2)) begin
                $display("PASS");
                $display("  Outputs: done_chan1=%b, done_chan2=%b",
                         done_chan1, done_chan2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_chan1=%b, done_chan2=%b",
                         expected_done_chan1, expected_done_chan2);
                $display("  Got:      done_chan1=%b, done_chan2=%b",
                         done_chan1, done_chan2);
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
        $dumpvars(0,clk, enable_chan1, enable_chan2, req_chan1, req_chan2, rst_n, done_chan1, done_chan2);
    end

endmodule
