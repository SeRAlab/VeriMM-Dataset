`timescale 1ns/1ps

module sync_up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg enable;
    reg sync_reset;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_down_counter dut (
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .sync_reset(sync_reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sync_reset = 1;
            direction = 1;
            enable = 0;
            @(posedge clk);
            #1;
            sync_reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count Up 5 cycles", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count Down (Wrap 0 to 15)", test_num);
            reset_dut();
            enable = 1;
            direction = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal Check (Pause counting)", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count Up Wrap-around (15 to 0)", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direction Switch mid-count", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(10) @(posedge clk);
            direction = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Priority Check", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(5) @(posedge clk);
            sync_reset = 1;
            @(posedge clk);
            sync_reset = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_down_counter Testbench");
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
        input [3:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, direction, enable, sync_reset, count_out);
    end

endmodule
