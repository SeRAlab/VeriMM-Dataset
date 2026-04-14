`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .Vin(Vin),
        .Vref(Vref),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Normal Regulation (Vin > Vref)", test_num);
        Vin = 8'd200;
        Vref = 8'd100;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Boundary Condition (Vin = Vref)", test_num);
        Vin = 8'd150;
        Vref = 8'd150;
        #1;

        check_outputs(8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Dropout Mode (Vin < Vref)", test_num);
        Vin = 8'd50;
        Vref = 8'd100;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Zero Input Voltage", test_num);
        Vin = 8'd0;
        Vref = 8'd100;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Zero Reference Voltage", test_num);
        Vin = 8'd100;
        Vref = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Maximum Input, Mid-range Reference", test_num);
        Vin = 8'hFF;
        Vref = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Full Scale Output", test_num);
        Vin = 8'hFF;
        Vref = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Low Voltage Operation", test_num);
        Vin = 8'd10;
        Vref = 8'd5;
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
        testcase008();
        
        
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
