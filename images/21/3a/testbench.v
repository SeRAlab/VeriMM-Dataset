`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg reset;
    reg [9:0] temp_in;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .enable(enable),
        .reset(reset),
        .temp_in(temp_in),
        .alert(alert)
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
            @(posedge enable);
            #1 reset = 0;
            @(posedge enable);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Temperature high trigger (>75)", test_num);
            reset_dut();
            temp_in = 10'd80;
            @(posedge enable);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Temperature low range (<60)", test_num);
            reset_dut();
            temp_in = 10'd50;
            @(posedge enable);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Intermediate temperature (no change from 0)", test_num);
            reset_dut();
            temp_in = 10'd70;
            @(posedge enable);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Intermediate temperature (no change from 1)", test_num);
            reset_dut();

            temp_in = 10'd90;
            @(posedge enable);

            #1 temp_in = 10'd65;
            @(posedge enable);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary check at 75", test_num);
            reset_dut();
            temp_in = 10'd75;
            @(posedge enable);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary check at 76", test_num);
            reset_dut();
            temp_in = 10'd76;
            @(posedge enable);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary check at 60 (stay active)", test_num);
            reset_dut();
            temp_in = 10'd80;
            @(posedge enable);
            #1 temp_in = 10'd60;
            @(posedge enable);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Boundary check at 59 (clear alert)", test_num);
            reset_dut();
            temp_in = 10'd80;
            @(posedge enable);
            #1 temp_in = 10'd59;
            @(posedge enable);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Maximum temperature value (1023)", test_num);
            reset_dut();
            temp_in = 10'd1023;
            @(posedge enable);
            #1 #1;
 check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_alert;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
        $dumpvars(0,enable, reset, temp_in, alert);
    end

endmodule
