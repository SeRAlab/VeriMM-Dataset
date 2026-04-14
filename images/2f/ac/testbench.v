`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire power_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .clk(clk),
        .enable(enable),
        .power_on(power_on)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;

            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Power-on on clock edge", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            enable = 1;
            @(posedge clk);
            #2;

            #3;
            enable = 0;
            #1;
            $display("Testcase %0d: Asynchronous Power-off (enable=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            enable = 1;
            #2;
            $display("Testcase %0d: Enable high, awaiting clock edge", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 0;
            repeat(3) @(posedge clk);
            #2;
            $display("Testcase %0d: Enable remains low", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            enable = 1;
            #2;
            enable = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Enable toggled before clock edge", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            enable = 1; @(posedge clk); #1;

            enable = 0; #1;

            enable = 1; @(posedge clk); #2;
            $display("Testcase %0d: Re-assertion after power cycle", test_num);
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
        $display("power_gating_controller Testbench");
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
        input expected_power_on;
        begin
            if (expected_power_on === (expected_power_on ^ power_on ^ expected_power_on)) begin
                $display("PASS");
                $display("  Outputs: power_on=%b",
                         power_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_on=%b",
                         expected_power_on);
                $display("  Got:      power_on=%b",
                         power_on);
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
        $dumpvars(0,clk, enable, power_on);
    end

endmodule
