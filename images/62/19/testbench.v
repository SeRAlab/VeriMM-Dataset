`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Sensor;
    reg Start;
    wire Actuator;
    wire G1__prevSensor;
    wire G1__prevStart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sensor(Sensor),
        .Start(Start),
        .Actuator(Actuator),
        .G1__prevSensor(G1__prevSensor),
        .G1__prevStart(G1__prevStart)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initializing system (Start=0, Sensor=0)", test_num);

            Start = 0;
            Sensor = 0;
            #10;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Triggering Start (Start=1, Sensor=0)", test_num);

            Start = 0; Sensor = 0;
            #5;

            Start = 1;
            Sensor = 0;
            #10;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Releasing Start (Start=0, Sensor=0) - Expecting Hold", test_num);

            Start = 0; Sensor = 0; #5;
            Start = 1; Sensor = 0; #10;

            Start = 0;
            Sensor = 0;
            #10;


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Triggering Sensor (Start=0, Sensor=1)", test_num);

            Start = 0; Sensor = 0; #5;
            Start = 1; Sensor = 0; #10;

            Start = 0;
            Sensor = 1;
            #10;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Both Start and Sensor High", test_num);

            Start = 0; Sensor = 0;
            #5;

            Start = 1;
            Sensor = 1;
            #10;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequence Transition (0,0 -> 1,0 -> 1,1 -> 0,1)", test_num);
            Start = 0; Sensor = 0; #5;
            Start = 1; Sensor = 0; #5;
            Start = 1; Sensor = 1; #5;
            Start = 0; Sensor = 1;
            #10;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_Actuator;
        input expected_G1__prevSensor;
        input expected_G1__prevStart;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Actuator === (expected_Actuator ^ Actuator ^ expected_Actuator) &&
                expected_G1__prevSensor === (expected_G1__prevSensor ^ G1__prevSensor ^ expected_G1__prevSensor) &&
                expected_G1__prevStart === (expected_G1__prevStart ^ G1__prevStart ^ expected_G1__prevStart)) begin
                $display("PASS");
                $display("  Outputs: Actuator=%b, G1__prevSensor=%b, G1__prevStart=%b",
                         Actuator, G1__prevSensor, G1__prevStart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Actuator=%b, G1__prevSensor=%b, G1__prevStart=%b",
                         expected_Actuator, expected_G1__prevSensor, expected_G1__prevStart);
                $display("  Got:      Actuator=%b, G1__prevSensor=%b, G1__prevStart=%b",
                         Actuator, G1__prevSensor, G1__prevStart);
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

endmodule
