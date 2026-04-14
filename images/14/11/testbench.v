`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] current_voltage;
    reg [9:0] threshold;
    wire current_exceeds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .current_voltage(current_voltage),
        .threshold(threshold),
        .current_exceeds(current_exceeds)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Current voltage below threshold", test_num);
            current_voltage = 10'd100;
            threshold = 10'd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Current voltage equal to threshold", test_num);
            current_voltage = 10'd500;
            threshold = 10'd500;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Current voltage above threshold", test_num);
            current_voltage = 10'd800;
            threshold = 10'd300;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Minimum boundary values (0 vs 0)", test_num);
            current_voltage = 10'd0;
            threshold = 10'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Maximum boundary values (1023 vs 1023)", test_num);
            current_voltage = 10'd1023;
            threshold = 10'd1023;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Maximum voltage vs minimum threshold", test_num);
            current_voltage = 10'd1023;
            threshold = 10'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Minimum voltage vs maximum threshold", test_num);
            current_voltage = 10'd0;
            threshold = 10'd1023;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Off-by-one check (Below)", test_num);
            current_voltage = 10'd511;
            threshold = 10'd512;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Off-by-one check (Above)", test_num);
            current_voltage = 10'd513;
            threshold = 10'd512;
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
        $display("current_sensor Testbench");
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
        input expected_current_exceeds;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_current_exceeds === (expected_current_exceeds ^ current_exceeds ^ expected_current_exceeds)) begin
                $display("PASS");
                $display("  Outputs: current_exceeds=%b",
                         current_exceeds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_exceeds=%b",
                         expected_current_exceeds);
                $display("  Got:      current_exceeds=%b",
                         current_exceeds);
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
