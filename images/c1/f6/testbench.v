`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data_in;
    reg load;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clock(clock),
        .data_in(data_in),
        .load(load),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            load = 1;
            data_in = 4'b0000;
            @(posedge clock);
            #1;
            load = 0;
            data_in = 4'b0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Incrementing for 5 clock cycles...", test_num);
            reset_dut();
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading value 10 (0xA)...", test_num);
            reset_dut();
            load = 1;
            data_in = 4'd10;
            @(posedge clock);
            #1;
            load = 0;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap around from 15 to 0...", test_num);
            reset_dut();
            load = 1;
            data_in = 4'd15;
            @(posedge clock);
            #1;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counting 18 cycles (should result in 2)...", test_num);
            reset_dut();
            repeat(18) @(posedge clock);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verifying load priority...", test_num);
            reset_dut();
            repeat(3) @(posedge clock);
            load = 1;
            data_in = 4'd7;
            @(posedge clock);
            #1;
            load = 0;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Holding load signal high...", test_num);
            reset_dut();
            load = 1;
            data_in = 4'd12;
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(4'd12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [3:0] expected_count;
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
        $dumpvars(0,clock, data_in, load, count);
    end

endmodule
