`timescale 1ns/1ps

module carrier_frequency_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg modulated_in;
    wire recovered_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_frequency_recovery dut (
        .clk(clk),
        .modulated_in(modulated_in),
        .recovered_clk(recovered_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            modulated_in = 0;
            repeat (2) @(posedge clk);
            #1 rst_n = 1;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_pulse;

        begin
            @(posedge clk);
            #1 modulated_in = 1;
            repeat (3) @(posedge clk);
            #1 modulated_in = 0;
            repeat (3) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Two rising edges", test_num);
            reset_dut();
            send_pulse();
            send_pulse();
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single rising edge", test_num);
            reset_dut();
            send_pulse();
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Three rising edges", test_num);
            reset_dut();
            send_pulse();
            send_pulse();
            send_pulse();
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Four rising edges", test_num);
            reset_dut();
            send_pulse();
            send_pulse();
            send_pulse();
            send_pulse();
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Pulse then long high duration", test_num);
            reset_dut();
            @(posedge clk);
            #1 modulated_in = 1;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        input expected_recovered_clk;
        begin
            if (expected_recovered_clk === (expected_recovered_clk ^ recovered_clk ^ expected_recovered_clk)) begin
                $display("PASS");
                $display("  Outputs: recovered_clk=%b",
                         recovered_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_clk=%b",
                         expected_recovered_clk);
                $display("  Got:      recovered_clk=%b",
                         recovered_clk);
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
        $dumpvars(0,clk, modulated_in, recovered_clk);
    end

endmodule
