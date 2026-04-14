`timescale 1ns/1ps

module temperature_monitor_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg reset;
    reg [4:0] temp_in;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_monitor dut (
        .enable(enable),
        .reset(reset),
        .temp_in(temp_in),
        .alarm(alarm)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            reset = 1;
            temp_in = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Temperature below threshold (15°C)", test_num);
            temp_in = 5'd15;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Temperature at threshold (20°C)", test_num);
            temp_in = 5'd20;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Temperature above threshold (25°C)", test_num);
            temp_in = 5'd25;
            #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Reset clearing an active alarm", test_num);
            temp_in = 5'd30;
            #20;

            if (alarm == 1'b1) begin
                reset = 1;
                #20;
                reset = 0;
                #10;
                #1;

                check_outputs(1'b0);
            end else begin
                $display("FAIL: Alarm did not trigger before reset test");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Maximum temperature (31°C)", test_num);
            temp_in = 5'b11111;
            #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Temperature drop without reset (Checking latch behavior)", test_num);
            temp_in = 5'd28;
            #20;
            temp_in = 5'd10;
            #20;


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
        $display("temperature_monitor Testbench");
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
        input expected_alarm;
        begin
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b",
                         alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b",
                         expected_alarm);
                $display("  Got:      alarm=%b",
                         alarm);
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
        $dumpvars(0,enable, reset, temp_in, alarm);
    end

endmodule
