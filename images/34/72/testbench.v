`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Imax;
    reg [7:0] Vin;
    reg enable;
    wire [7:0] Vout;
    wire overcurrent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .Imax(Imax),
        .Vin(Vin),
        .enable(enable),
        .Vout(Vout),
        .overcurrent(overcurrent)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Regulator Disabled", test_num);
            enable = 0;
            Vin = 8'hFF;
            Imax = 8'h80;
            #10;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation (Vin < Target)", test_num);
            enable = 1;
            Vin = 8'h40;
            Imax = 8'hFF;
            #10;

            #1;


            check_outputs(8'h40, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Voltage Regulation (Vin > Target)", test_num);
            enable = 1;
            Vin = 8'hA0;
            Imax = 8'hFF;
            #10;

            #1;


            check_outputs(8'h80, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overcurrent Detection (Low Imax)", test_num);
            enable = 1;
            Vin = 8'h60;
            Imax = 8'h30;
            #10;



            #1;




            check_outputs(8'h60, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overcurrent Detection at Regulated Limit", test_num);
            enable = 1;
            Vin = 8'hF0;
            Imax = 8'h70;
            #10;

            #1;


            check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Recovery from Overcurrent", test_num);
            enable = 1;
            Vin = 8'h50;
            Imax = 8'h10;
            #5;
            Imax = 8'hFF;
            #10;
            #1;

            check_outputs(8'h50, 1'b0);
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
        input expected_overcurrent;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout) &&
                expected_overcurrent === (expected_overcurrent ^ overcurrent ^ expected_overcurrent)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h, overcurrent=%b",
                         Vout, overcurrent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h, overcurrent=%b",
                         expected_Vout, expected_overcurrent);
                $display("  Got:      Vout=%h, overcurrent=%b",
                         Vout, overcurrent);
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
