`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] vin;
    wire [4:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .vin(vin),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            vin = 5'd0;
            $display("Test %0d: Minimum Input (0)", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            vin = 5'd12;
            $display("Test %0d: Mid-range Input (12)", test_num);
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            vin = 5'd25;
            $display("Test %0d: Boundary Input - Just before clamping (25)", test_num);
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            vin = 5'd26;
            $display("Test %0d: Boundary Input - Just after clamping (26)", test_num);
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            vin = 5'd31;
            $display("Test %0d: Maximum Input (31)", test_num);
            #1;

            check_outputs(5'd25);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
