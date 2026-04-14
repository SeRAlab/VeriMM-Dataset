`timescale 1ns/1ps

module heater_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg temperature_high;
    reg temperature_low;
    wire heater_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    heater_controller dut (
        .areset(areset),
        .clk(clk),
        .temperature_high(temperature_high),
        .temperature_low(temperature_low),
        .heater_on(heater_on)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            temperature_low = 0;
            temperature_high = 0;
            #12;
            areset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition Off -> Off (low=0)", test_num);
            reset_dut();
            @(posedge clk);
            temperature_low = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition Off -> On (low=1)", test_num);
            reset_dut();
            @(posedge clk);
            temperature_low = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition On -> On (high=0)", test_num);
            reset_dut();

            @(posedge clk);
            temperature_low = 1;
            @(posedge clk);

            temperature_high = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition On -> Off (high=1)", test_num);
            reset_dut();

            @(posedge clk);
            temperature_low = 1;
            @(posedge clk);

            temperature_high = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset while in state On", test_num);
            reset_dut();

            @(posedge clk);
            temperature_low = 1;
            @(posedge clk);
            #1;

            areset = 1;
            #1;
            #1;

            check_outputs(1'b0);
            areset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("heater_controller Testbench");
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
        input expected_heater_on;
        begin
            if (expected_heater_on === (expected_heater_on ^ heater_on ^ expected_heater_on)) begin
                $display("PASS");
                $display("  Outputs: heater_on=%b",
                         heater_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heater_on=%b",
                         expected_heater_on);
                $display("  Got:      heater_on=%b",
                         heater_on);
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
        $dumpvars(0,areset, clk, temperature_high, temperature_low, heater_on);
    end

endmodule
