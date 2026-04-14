`timescale 1ns/1ps

module pulse_stretcher_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din_pulse;
    reg rst_n;
    wire dout_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_stretcher dut (
        .clk(clk),
        .din_pulse(din_pulse),
        .rst_n(rst_n),
        .dout_pulse(dout_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            din_pulse = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse high during stretch", test_num);
            reset_dut();


            din_pulse = 1;
            @(posedge clk);
            #1;
            din_pulse = 0;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse low after stretch completion", test_num);
            reset_dut();


            din_pulse = 1;
            @(posedge clk);
            #1;
            din_pulse = 0;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse high at 4th cycle", test_num);
            reset_dut();


            din_pulse = 1;
            @(posedge clk);
            #1;
            din_pulse = 0;


            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %04d: Reset during active stretch", test_num);
            reset_dut();


            din_pulse = 1;
            @(posedge clk);
            #1;
            din_pulse = 0;


            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
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
        $display("pulse_stretcher Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_dout_pulse;
        begin
            if (expected_dout_pulse === (expected_dout_pulse ^ dout_pulse ^ expected_dout_pulse)) begin
                $display("PASS");
                $display("  Outputs: dout_pulse=%b",
                         dout_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_pulse=%b",
                         expected_dout_pulse);
                $display("  Got:      dout_pulse=%b",
                         dout_pulse);
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
        $dumpvars(0,clk, din_pulse, rst_n, dout_pulse);
    end

endmodule
