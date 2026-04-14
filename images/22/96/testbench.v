`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] vin;
    wire [4:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .vin(vin),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Input (vin = 0)", test_num);
            vin = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Range Input (vin = 7)", test_num);
            vin = 5'd7;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Non-Clamped Input (vin = 15)", test_num);
            vin = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Clamped Input (vin = 16)", test_num);
            vin = 5'd16;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Range Clamped Input (vin = 25)", test_num);
            vin = 5'd25;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Input (vin = 31)", test_num);
            vin = 5'd31;
            #1;

            check_outputs(5'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
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
        input [4:0] expected_vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
