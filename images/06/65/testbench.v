`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Vin;
    wire [31:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .Vin(Vin),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Minimum Input (0)", test_num);
        Vin = 16'h0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Maximum Input (65535)", test_num);
        Vin = 16'hFFFF;
        #1;

        check_outputs(32'h40A0_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Mid-point Input (32768)", test_num);
        Vin = 16'd32768;
        #1;

        check_outputs(32'h4020_0040);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Lower Quarter Input (16384)", test_num);
        Vin = 16'd16384;
        #1;

        check_outputs(32'h3FA0_0020);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Upper Quarter Input (49152)", test_num);
        Vin = 16'd49152;
        #1;

        check_outputs(32'h4070_0060);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Input mapping to 1.0V (13107)", test_num);
        Vin = 16'd13107;
        #1;

        check_outputs(32'h3F80_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Input mapping to 2.0V (26214)", test_num);
        Vin = 16'd26214;
        #1;

        check_outputs(32'h4000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Resolution Check (Vin=1)", test_num);
        Vin = 16'd1;
        #1;

        check_outputs(32'h38A0_0080);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
        input [31:0] expected_Vout;
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
