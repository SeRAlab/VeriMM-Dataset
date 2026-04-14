`timescale 1ns/1ps

module up_down_counter_16bit_async_clear_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg direction;
    reg enable;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_16bit_async_clear dut (
        .clear(clear),
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            direction = 0;
            #12;
            clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            enable = 1;
            direction = 1;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            enable = 1;
            direction = 0;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFB);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            direction = 1;
            enable = 1;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            enable = 0;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd5);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            enable = 1;
            direction = 1;
            for (i = 0; i < 20; i = i + 1) @(posedge clk);
            direction = 0;
            for (i = 0; i < 8; i = i + 1) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd12);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            enable = 1;
            direction = 1;
            for (i = 0; i < 50; i = i + 1) @(posedge clk);
            #2;
            clear = 1;
            #2;
            #1;

            check_outputs(16'h0000);
            clear = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();


            enable = 1;
            direction = 0;
            @(posedge clk);
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_16bit_async_clear Testbench");
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
        input [15:0] expected_count;
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
