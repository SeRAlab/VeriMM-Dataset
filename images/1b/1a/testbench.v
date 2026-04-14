`timescale 1ns/1ps

module SwitchingRegulator_tb;

    // Testbench signals (combinational circuit)
    reg Ctrl;
    reg Enable;
    reg [4:0] Vin;
    wire [4:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SwitchingRegulator dut (
        .Ctrl(Ctrl),
        .Enable(Enable),
        .Vin(Vin),
        .Vout(Vout)
    );
    task testcase001;

        begin
            $display("Test Case 001: System Disabled, Ctrl Low");
            Enable = 1'b0;
            Ctrl = 1'b0;
            Vin = 5'd10;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: System Disabled, Ctrl High");
            Enable = 1'b0;
            Ctrl = 1'b1;
            Vin = 5'd15;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: System Enabled, Ctrl High (Set to 5V)");
            Enable = 1'b1;
            Ctrl = 1'b1;
            Vin = 5'd20;
            #10;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: System Enabled, Ctrl Low (Set to 0V)");
            Enable = 1'b1;
            Ctrl = 1'b0;
            Vin = 5'd20;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: System Enabled, Ctrl High, Low Input Voltage");
            Enable = 1'b1;
            Ctrl = 1'b1;
            Vin = 5'd5;
            #10;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Toggle Enable while Ctrl is High");
            Ctrl = 1'b1;
            Vin = 5'd12;
            Enable = 1'b1;
            #5;
            Enable = 1'b0;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Toggle Ctrl while Enabled");
            Enable = 1'b1;
            Vin = 5'd12;
            Ctrl = 1'b0;
            #5;
            Ctrl = 1'b1;
            #10;
            #1;

            check_outputs(5'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SwitchingRegulator Testbench");
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
        input [4:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
