`timescale 1ns/1ps

module carrier_frequency_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] osc_freq;
    reg [1:0] recv_signal;
    reg reset;
    wire [1:0] recovered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_frequency_recovery dut (
        .clk(clk),
        .osc_freq(osc_freq),
        .recv_signal(recv_signal),
        .reset(reset),
        .recovered_signal(recovered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            osc_freq = 2'b00;
            recv_signal = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            osc_freq = 2'b00;
            recv_signal = 2'b11;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            osc_freq = 2'b01;
            recv_signal = 2'b10;
            repeat(20) begin
                @(posedge clk);

            end

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            osc_freq = 2'b11;
            recv_signal = 2'b01;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            osc_freq = 2'b01;
            recv_signal = 2'b11;
            repeat(10) @(posedge clk);
            osc_freq = 2'b10;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_frequency_recovery Testbench");
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
        input [1:0] expected_recovered_signal;
        begin
            if (expected_recovered_signal === (expected_recovered_signal ^ recovered_signal ^ expected_recovered_signal)) begin
                $display("PASS");
                $display("  Outputs: recovered_signal=%h",
                         recovered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_signal=%h",
                         expected_recovered_signal);
                $display("  Got:      recovered_signal=%h",
                         recovered_signal);
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
        $dumpvars(0,clk, osc_freq, recv_signal, reset, recovered_signal);
    end

endmodule
