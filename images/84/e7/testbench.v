`timescale 1ns/1ps

module up_down_counter_8bit_sync_clear_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg direction;
    reg enable;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_8bit_sync_clear dut (
        .clear(clear),
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            direction = 0;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Counting Up (10 cycles)", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Counting Down (From 10 back to 5)", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(10) @(posedge clk);
            direction = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify Enable=0 pauses counter", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Synchronous Clear priority", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(10) @(posedge clk);
            clear = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Underflow (0 to 255)", test_num);
            reset_dut();
            enable = 1;
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Overflow (Wrap around 255 to 1)", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(257) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Immediate Direction Change", test_num);
            reset_dut();
            enable = 1;
            direction = 1;
            repeat(3) @(posedge clk);
            direction = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_8bit_sync_clear Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clear, clk, direction, enable, count);
    end

endmodule
