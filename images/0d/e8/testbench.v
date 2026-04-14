`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Vin;
    reg enable;
    wire [4:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vin(Vin),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High, Vin = 10", test_num);
            enable = 1'b1;
            Vin = 5'd10;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Low, Vin = 10", test_num);
            enable = 1'b0;
            Vin = 5'd10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High, Vin = 31 (Max)", test_num);
            enable = 1'b1;
            Vin = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Low, Vin = 31 (Max)", test_num);
            enable = 1'b0;
            Vin = 5'd31;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High, Vin = 0 (Min)", test_num);
            enable = 1'b1;
            Vin = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Low, Vin = 0 (Min)", test_num);
            enable = 1'b0;
            Vin = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High, Vin = 5", test_num);
            enable = 1'b1;
            Vin = 5'd5;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable High, Vin = 25", test_num);
            enable = 1'b1;
            Vin = 5'd25;
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
