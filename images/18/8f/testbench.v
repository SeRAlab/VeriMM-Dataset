`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg power_gating;
    reg reset;
    wire power_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .clk(clk),
        .enable(enable),
        .power_gating(power_gating),
        .reset(reset),
        .power_state(power_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            power_gating = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High - Power ON", test_num);
            reset_dut();
            enable = 1;
            power_gating = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High - Power OFF", test_num);
            reset_dut();
            enable = 1;
            power_gating = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Low - Hold Previous High State", test_num);
            reset_dut();

            enable = 1;
            power_gating = 1;
            @(posedge clk);

            #1 enable = 0;
            power_gating = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Low - Hold Previous Low State", test_num);
            reset_dut();

            enable = 1;
            power_gating = 0;
            @(posedge clk);

            #1 enable = 0;
            power_gating = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic Toggle Enable", test_num);
            reset_dut();

            enable = 1;
            power_gating = 1;
            @(posedge clk);

            #1 enable = 0;
            power_gating = 0;
            @(posedge clk);

            #1 enable = 1;
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
        input expected_power_state;
        begin
            if (expected_power_state === (expected_power_state ^ power_state ^ expected_power_state)) begin
                $display("PASS");
                $display("  Outputs: power_state=%b",
                         power_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_state=%b",
                         expected_power_state);
                $display("  Got:      power_state=%b",
                         power_state);
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
        $dumpvars(0,clk, enable, power_gating, reset, power_state);
    end

endmodule
