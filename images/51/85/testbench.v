`timescale 1ns/1ps

module automatic_door_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg sensor;
    wire open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    automatic_door dut (
        .clk(clk),
        .resetn(resetn),
        .sensor(sensor),
        .open(open)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            sensor = 0;
            @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset (Sensor=0)", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Door opens when sensor is triggered", test_num);
            reset_dut();
            sensor = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Door closes when sensor is released", test_num);
            reset_dut();
            sensor = 1;
            @(posedge clk);
            sensor = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Door stays open while sensor is high", test_num);
            reset_dut();
            sensor = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset overrides sensor and closes door", test_num);
            reset_dut();
            sensor = 1;
            @(posedge clk);
            resetn = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("automatic_door Testbench");
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
        input expected_open;
        begin
            if (expected_open === (expected_open ^ open ^ expected_open)) begin
                $display("PASS");
                $display("  Outputs: open=%b",
                         open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: open=%b",
                         expected_open);
                $display("  Got:      open=%b",
                         open);
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
        $dumpvars(0,clk, resetn, sensor, open);
    end

endmodule
