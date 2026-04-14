`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire OverVoltage;
    wire UnderVoltage;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vin(Vin),
        .Vref(Vref),
        .OverVoltage(OverVoltage),
        .UnderVoltage(UnderVoltage),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Regulated Region (Vin > Vref)", test_num);
        Vin = 8'd200;
        Vref = 8'd100;



        #1;




        check_outputs(1'b0, 1'b0, 8'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary condition (Vin = Vref)", test_num);
        Vin = 8'd150;
        Vref = 8'd150;



        #1;




        check_outputs(1'b0, 1'b0, 8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Dropout Region - Safe (Vref - 10% < Vin < Vref)", test_num);
        Vin = 8'd95;
        Vref = 8'd100;



        #1;




        check_outputs(1'b0, 1'b0, 8'd95);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: UnderVoltage Region (Vin < Vref - 10%)", test_num);
        Vin = 8'd80;
        Vref = 8'd100;



        #1;




        check_outputs(1'b0, 1'b1, 8'd80);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum Input (Vin = 0)", test_num);
        Vin = 8'd0;
        Vref = 8'd50;



        #1;




        check_outputs(1'b0, 1'b1, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High Voltage Regulation", test_num);
        Vin = 8'd255;
        Vref = 8'd200;



        #1;




        check_outputs(1'b0, 1'b0, 8'd200);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Vref Integer Math Check (Vref = 20)", test_num);
        Vin = 8'd17;
        Vref = 8'd20;



        #1;




        check_outputs(1'b0, 1'b1, 8'd17);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Vref Safe Check (Vref = 20, Vin = 18)", test_num);
        Vin = 8'd18;
        Vref = 8'd20;



        #1;




        check_outputs(1'b0, 1'b0, 8'd18);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO Testbench");
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
        input expected_OverVoltage;
        input expected_UnderVoltage;
        input [7:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OverVoltage === (expected_OverVoltage ^ OverVoltage ^ expected_OverVoltage) &&
                expected_UnderVoltage === (expected_UnderVoltage ^ UnderVoltage ^ expected_UnderVoltage) &&
                expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: OverVoltage=%b, UnderVoltage=%b, Vout=%h",
                         OverVoltage, UnderVoltage, Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OverVoltage=%b, UnderVoltage=%b, Vout=%h",
                         expected_OverVoltage, expected_UnderVoltage, expected_Vout);
                $display("  Got:      OverVoltage=%b, UnderVoltage=%b, Vout=%h",
                         OverVoltage, UnderVoltage, Vout);
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
