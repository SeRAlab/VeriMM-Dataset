`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_in;
    wire [2:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing lower bound of Low range (0V)", test_num);
        voltage_in = 5'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing upper bound of Low range (10V)", test_num);
        voltage_in = 5'd10;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing lower bound of Medium range (11V)", test_num);
        voltage_in = 5'd11;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing middle of Medium range (15V)", test_num);
        voltage_in = 5'd15;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing upper bound of Medium range (20V)", test_num);
        voltage_in = 5'd20;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing lower bound of High range (21V)", test_num);
        voltage_in = 5'd21;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing middle of High range (26V)", test_num);
        voltage_in = 5'd26;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing upper bound of High range (31V)", test_num);
        voltage_in = 5'd31;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing a random value in Low range (5V)", test_num);
        voltage_in = 5'd5;
        #1;

        check_outputs(3'b000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_sensor Testbench");
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
        input [2:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
