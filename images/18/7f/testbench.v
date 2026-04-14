`timescale 1ns/1ps

module wifi_power_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg power_enable;
    reg reset;
    wire wifi_power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_power_controller dut (
        .clk(clk),
        .power_enable(power_enable),
        .reset(reset),
        .wifi_power(wifi_power)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            power_enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Power On (2 cycle delay)", test_num);
            reset_dut();
            power_enable = 1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Immediate Power Off", test_num);
            reset_dut();

            power_enable = 1;
            repeat(2) @(posedge clk);
            #1;

            power_enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupted Power On (Enable low after 1 cycle)", test_num);
            reset_dut();
            power_enable = 1;
            @(posedge clk);
            #1;
            power_enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Timing Verification (Check at Cycle 1)", test_num);
            reset_dut();
            power_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during startup", test_num);
            reset_dut();
            power_enable = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained Power On State", test_num);
            reset_dut();
            power_enable = 1;
            repeat(5) @(posedge clk);
            #2;
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
        $display("wifi_power_controller Testbench");
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
        input expected_wifi_power;
        begin
            if (expected_wifi_power === (expected_wifi_power ^ wifi_power ^ expected_wifi_power)) begin
                $display("PASS");
                $display("  Outputs: wifi_power=%b",
                         wifi_power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wifi_power=%b",
                         expected_wifi_power);
                $display("  Got:      wifi_power=%b",
                         wifi_power);
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
        $dumpvars(0,clk, power_enable, reset, wifi_power);
    end

endmodule
