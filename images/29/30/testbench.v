`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .Vin(Vin),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = 1;
        Vin = 8'd0;
        $display("Test Case %03d: Vin = %d (Expected: 0)", test_num, Vin);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Vin = 8'd3;
        $display("Test Case %03d: Vin = %d (Expected: 3)", test_num, Vin);
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Vin = 8'd4;
        $display("Test Case %03d: Vin = %d (Expected: 4)", test_num, Vin);
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Vin = 8'd5;
        $display("Test Case %03d: Vin = %d (Boundary Case, Expected: 5)", test_num, Vin);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Vin = 8'd6;
        $display("Test Case %03d: Vin = %d (Expected: 5)", test_num, Vin);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Vin = 8'd100;
        $display("Test Case %03d: Vin = %d (Expected: 5)", test_num, Vin);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Vin = 8'd255;
        $display("Test Case %03d: Vin = %d (Max Input, Expected: 5)", test_num, Vin);
        #1;

        check_outputs(8'd5);
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
        input [7:0] expected_Vout;
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
