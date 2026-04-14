`timescale 1ns/1ps

module water_pump_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg level;
    reg resetn;
    wire pump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    water_pump_control dut (
        .clk(clk),
        .level(level),
        .resetn(resetn),
        .pump(pump)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            level = 0;
            @(negedge clk);
            resetn = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Level Activation", test_num);
            reset_dut();
            level = 1;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sufficient Level Stay Off", test_num);
            reset_dut();
            level = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pump Deactivation when level restored", test_num);
            reset_dut();
            level = 1;
            @(negedge clk);
            level = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Oscillating level test", test_num);
            reset_dut();
            level = 1; @(negedge clk);
            level = 0; @(negedge clk);
            level = 1; @(negedge clk);
            level = 0; @(negedge clk);
            level = 1; @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset override during activity", test_num);
            reset_dut();
            level = 1;
            @(negedge clk);
            resetn = 0;
            @(negedge clk);

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
        $display("water_pump_control Testbench");
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
        input expected_pump;
        begin
            if (expected_pump === (expected_pump ^ pump ^ expected_pump)) begin
                $display("PASS");
                $display("  Outputs: pump=%b",
                         pump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pump=%b",
                         expected_pump);
                $display("  Got:      pump=%b",
                         pump);
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
        $dumpvars(0,clk, level, resetn, pump);
    end

endmodule
