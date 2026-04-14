`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg kick;
    reg reset;
    wire [3:0] counter;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .kick(kick),
        .reset(reset),
        .counter(counter),
        .timeout(timeout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            kick = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Incrementing", test_num);
            reset_dut();
            repeat(5) begin
                kick = 1;
                @(posedge clk);
            end
            kick = 0;
            #1 #1;
 check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Holding value without kick", test_num);
            reset_dut();
            repeat(3) begin
                kick = 1;
                @(posedge clk);
            end
            kick = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Timeout trigger (Reset to zero)", test_num);
            reset_dut();

            repeat(4) begin
                kick = 1;
                @(posedge clk);
            end

            kick = 0;
            repeat(20) @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Recovery after timeout", test_num);
            reset_dut();

            kick = 0;
            repeat(20) @(posedge clk);

            repeat(6) begin
                kick = 1;
                @(posedge clk);
            end
            kick = 0;
            #1 #1;
 check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Intermittent kicking prevents timeout", test_num);
            reset_dut();

            repeat(4) begin
                kick = 1;
                @(posedge clk);
                kick = 0;
                repeat(2) @(posedge clk);
            end

            #1 #1;
 check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Hardware reset priority", test_num);
            reset_dut();
            repeat(5) begin
                kick = 1;
                @(posedge clk);
            end

            reset = 1;
            @(posedge clk);
            reset = 0;
            kick = 0;
            #1 #1;
 check_outputs(4'd0, 1'b0);
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
        testcase006();
        
        
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
        input [3:0] expected_counter;
        input expected_timeout;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, timeout=%b",
                         counter, timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, timeout=%b",
                         expected_counter, expected_timeout);
                $display("  Got:      counter=%h, timeout=%b",
                         counter, timeout);
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
        $dumpvars(0,clk, kick, reset, counter, timeout);
    end

endmodule
