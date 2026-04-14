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
            $display("Test Case %0d: Vin < Vref", test_num);
            Vin = 8'd20;
            Vref = 8'd100;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Vin > Vref", test_num);
            Vin = 8'd150;
            Vref = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Vin == Vref", test_num);
            Vin = 8'd80;
            Vref = 8'd80;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Vin = 0", test_num);
            Vin = 8'd0;
            Vref = 8'd50;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Vref = 0", test_num);
            Vin = 8'd100;
            Vref = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Max values (Vin=255, Vref=255)", test_num);
            Vin = 8'd255;
            Vref = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Vin=255, Vref=128", test_num);
            Vin = 8'd255;
            Vref = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Vin=5, Vref=250", test_num);
            Vin = 8'd5;
            Vref = 8'd250;
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
