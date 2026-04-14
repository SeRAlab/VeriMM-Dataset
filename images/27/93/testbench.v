`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req;
    reg reset;
    reg [3:0] target_frequency;
    reg [3:0] target_voltage;
    wire [3:0] current_frequency;
    wire [3:0] current_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .target_frequency(target_frequency),
        .target_voltage(target_voltage),
        .current_frequency(current_frequency),
        .current_voltage(current_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            target_frequency = 0;
            target_voltage = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Increase both V and F from 0 to 5");
            test_num = test_num + 1;
            reset_dut();
            target_frequency = 5;
            target_voltage = 5;
            req = 1;

            repeat(6) @(posedge clk);
            req = 0;
            #1;

            check_outputs(5, 5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Increase to different targets (F=10, V=4)");
            test_num = test_num + 1;
            reset_dut();
            target_frequency = 10;
            target_voltage = 4;
            req = 1;

            repeat(11) @(posedge clk);
            req = 0;
            #1;

            check_outputs(10, 4);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Decrease V and F from 8 to 2");
            test_num = test_num + 1;
            reset_dut();

            target_frequency = 8;
            target_voltage = 8;
            req = 1;
            repeat(9) @(posedge clk);


            target_frequency = 2;
            target_voltage = 2;
            repeat(7) @(posedge clk);
            req = 0;
            #1;

            check_outputs(2, 2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Mixed direction (F: 0->8, V: 10->3)");
            test_num = test_num + 1;
            reset_dut();

            target_frequency = 0;
            target_voltage = 10;
            req = 1;
            repeat(11) @(posedge clk);


            target_frequency = 8;
            target_voltage = 3;

            repeat(9) @(posedge clk);
            req = 0;
            #1;

            check_outputs(8, 3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Target set but req=0 (No movement)");
            test_num = test_num + 1;
            reset_dut();
            target_frequency = 12;
            target_voltage = 12;
            req = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reach maximum 4-bit values (15)");
            test_num = test_num + 1;
            reset_dut();
            target_frequency = 15;
            target_voltage = 15;
            req = 1;
            repeat(16) @(posedge clk);
            req = 0;
            #1;

            check_outputs(15, 15);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Deasserting req halfway");
            test_num = test_num + 1;
            reset_dut();
            target_frequency = 10;
            target_voltage = 10;
            req = 1;
            repeat(5) @(posedge clk);
            req = 0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(5, 5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_current_frequency;
        input [3:0] expected_current_voltage;
        begin
            if (expected_current_frequency === (expected_current_frequency ^ current_frequency ^ expected_current_frequency) &&
                expected_current_voltage === (expected_current_voltage ^ current_voltage ^ expected_current_voltage)) begin
                $display("PASS");
                $display("  Outputs: current_frequency=%h, current_voltage=%h",
                         current_frequency, current_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_frequency=%h, current_voltage=%h",
                         expected_current_frequency, expected_current_voltage);
                $display("  Got:      current_frequency=%h, current_voltage=%h",
                         current_frequency, current_voltage);
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
        $dumpvars(0,clk, req, reset, target_frequency, target_voltage, current_frequency, current_voltage);
    end

endmodule
