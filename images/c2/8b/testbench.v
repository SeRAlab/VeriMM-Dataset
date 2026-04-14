`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] timer_duration;
    wire timer_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .reset(reset),
        .timer_duration(timer_duration),
        .timer_reset(timer_reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal operation with heartbeats", test_num);
            reset_dut();
            timer_duration = 32'd10;


            repeat(4) begin
                repeat(7) @(posedge clk);
                #1 reset = 1;
                @(posedge clk);
                #1 reset = 0;
            end



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Watchdog timeout trigger at duration", test_num);
            reset_dut();
            timer_duration = 32'd5;


            repeat(5) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verification of 1-cycle pulse width", test_num);
            reset_dut();
            timer_duration = 32'd5;


            repeat(5) @(posedge clk);
            #1;
            if (timer_reset !== 1'b1) begin
                $display("Sub-test Failed: Trigger did not occur at cycle 5");
            end


            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dynamic duration update", test_num);
            reset_dut();
            timer_duration = 32'd20;


            repeat(15) @(posedge clk);
            #1;
            if (timer_reset !== 1'b0) $display("Sub-test Failed: Premature trigger");



            timer_duration = 32'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Heartbeat reset at the very last moment", test_num);
            reset_dut();
            timer_duration = 32'd10;


            repeat(9) @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("watchdog_timer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_timer_reset;
        begin
            if (expected_timer_reset === (expected_timer_reset ^ timer_reset ^ expected_timer_reset)) begin
                $display("PASS");
                $display("  Outputs: timer_reset=%b",
                         timer_reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_reset=%b",
                         expected_timer_reset);
                $display("  Got:      timer_reset=%b",
                         timer_reset);
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
        $dumpvars(0,clk, reset, timer_duration, timer_reset);
    end

endmodule
