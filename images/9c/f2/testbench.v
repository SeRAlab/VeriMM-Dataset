`timescale 1ns/1ps

module up_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset;
    reg up;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_3bit dut (
        .clk(clk),
        .down(down),
        .reset(reset),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up = 0;
            down = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Increment");
            reset_dut();
            up = 1;
            down = 0;
            @(negedge clk);
            up = 0;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Up Wrap-around");
            reset_dut();
            up = 1;
            down = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end
            up = 0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Down Wrap-around");
            reset_dut();
            up = 0;
            down = 1;
            @(negedge clk);
            down = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Hold Value");
            reset_dut();

            up = 1;
            repeat(3) @(negedge clk);

            up = 0;
            down = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Decrement sequence");
            reset_dut();

            up = 1;
            repeat(5) @(negedge clk);

            up = 0;
            down = 1;
            repeat(2) @(negedge clk);
            down = 0;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Simultaneous Up/Down");
            reset_dut();

            up = 1;
            repeat(2) @(negedge clk);

            up = 1;
            down = 1;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Count to Max (7)");
            reset_dut();
            up = 1;
            repeat(7) @(negedge clk);
            up = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_3bit Testbench");
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, down, reset, up, count);
    end

endmodule
