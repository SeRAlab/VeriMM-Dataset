`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] current_in;
    reg [2:0] sample_count;
    wire [4:0] avg_current;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .clk(clk),
        .current_in(current_in),
        .sample_count(sample_count),
        .avg_current(avg_current)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            current_in = 0;
            sample_count = 7;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Sample Count 1", test_num);
            sample_count = 1;
            current_in = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Sample Count 2 (10, 20)", test_num);
            sample_count = 2;
            current_in = 5'd10; @(posedge clk);
            current_in = 5'd20; @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Sample Count 4 (4, 8, 12, 16)", test_num);
            sample_count = 4;
            current_in = 5'd4;  @(posedge clk);
            current_in = 5'd8;  @(posedge clk);
            current_in = 5'd12; @(posedge clk);
            current_in = 5'd16; @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Integer Truncation (Sum=32, Count=3)", test_num);
            sample_count = 3;
            current_in = 5'd10; @(posedge clk);
            current_in = 5'd10; @(posedge clk);
            current_in = 5'd12; @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Sample Count 7 (1...7)", test_num);
            sample_count = 7;
            current_in = 5'd1; @(posedge clk);
            current_in = 5'd2; @(posedge clk);
            current_in = 5'd3; @(posedge clk);
            current_in = 5'd4; @(posedge clk);
            current_in = 5'd5; @(posedge clk);
            current_in = 5'd6; @(posedge clk);
            current_in = 5'd7; @(posedge clk);
            #1;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Maximum Values (All 31)", test_num);
            sample_count = 2;
            current_in = 5'd31; @(posedge clk);
            current_in = 5'd31; @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input [4:0] expected_avg_current;
        begin
            if (expected_avg_current === (expected_avg_current ^ avg_current ^ expected_avg_current)) begin
                $display("PASS");
                $display("  Outputs: avg_current=%h",
                         avg_current);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg_current=%h",
                         expected_avg_current);
                $display("  Got:      avg_current=%h",
                         avg_current);
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
        $dumpvars(0,clk, current_in, sample_count, avg_current);
    end

endmodule
