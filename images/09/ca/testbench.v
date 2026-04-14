`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vmax;
    reg [7:0] Vtarget;
    reg enable;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .Vin(Vin),
        .Vmax(Vmax),
        .Vtarget(Vtarget),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 0;
            Vin = 8'd100;
            Vtarget = 8'd50;
            Vmax = 8'd80;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1;
            Vin = 8'd100;
            Vtarget = 8'd50;
            Vmax = 8'd80;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1;
            Vin = 8'd40;
            Vtarget = 8'd50;
            Vmax = 8'd80;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1;
            Vin = 8'd100;
            Vtarget = 8'd90;
            Vmax = 8'd70;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1;
            Vin = 8'd20;
            Vtarget = 8'd60;
            Vmax = 8'd40;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1;
            Vin = 8'hFF;
            Vtarget = 8'hFF;
            Vmax = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1;
            Vin = 8'd100;
            Vtarget = 8'd0;
            Vmax = 8'd80;
            #1;

            check_outputs(8'd0);
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
