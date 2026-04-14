`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vfb;
    reg [7:0] Vin;
    reg enable;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .Vfb(Vfb),
        .Vin(Vin),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable Low (Output must be zero)", test_num);
        enable = 1'b0;
        Vin = 8'hFF;
        Vfb = 8'h55;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High, Normal Regulation (Vin > Vfb)", test_num);
        enable = 1'b1;
        Vin = 8'd200;
        Vfb = 8'd50;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High, Low Differential (Vin > Vfb)", test_num);
        enable = 1'b1;
        Vin = 8'd100;
        Vfb = 8'd90;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High, Saturation/Dropout (Vin <= Vfb)", test_num);
        enable = 1'b1;
        Vin = 8'd50;
        Vfb = 8'd60;

        #1;


        check_outputs(8'd00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High, Maximum range check", test_num);
        enable = 1'b1;
        Vin = 8'hFF;
        Vfb = 8'h00;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable Toggle (Dynamic transition)", test_num);
        enable = 1'b1;
        Vin = 8'd100;
        Vfb = 8'd20;
        #5;
        enable = 1'b0;
        #1;

        check_outputs(8'd00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equal Inputs check", test_num);
        enable = 1'b1;
        Vin = 8'd128;
        Vfb = 8'd128;
        #1;

        check_outputs(8'd00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
