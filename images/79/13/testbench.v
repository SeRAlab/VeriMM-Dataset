`timescale 1ns/1ps

module binary_counter_with_overflow_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [1:0] count;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_with_overflow dut (
        .clk(clk),
        .enable(enable),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;

            repeat(4) begin
                @(posedge clk);
                if (count === 2'b00) begin
                    enable = 0;
                end
            end
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Idle state (Enable=0)", test_num);
            reset_dut();
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single increment (0 to 1)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count to 3 (No overflow yet)", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overflow check (3 to 0 wrap)", test_num);
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Clear overflow (0 to 1 after wrap)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Intermittent enable", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b10, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_with_overflow Testbench");
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
        input [1:0] expected_count;
        input expected_overflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflow=%b",
                         count, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflow=%b",
                         expected_count, expected_overflow);
                $display("  Got:      count=%h, overflow=%b",
                         count, overflow);
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
        $dumpvars(0,clk, enable, count, overflow);
    end

endmodule
