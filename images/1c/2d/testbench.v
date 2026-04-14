`timescale 1ns/1ps

module linear_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [2:0] control_signal;
    wire [7:0] Vout;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regulator dut (
        .Vin(Vin),
        .control_signal(control_signal),
        .Vout(Vout),
        .ready(ready)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Half Voltage (Control = 4/8)", test_num);
        Vin = 8'd100;
        control_signal = 3'b100;

        #1;


        check_outputs(8'd50, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Gain (Control = 0/8)", test_num);
        Vin = 8'd255;
        control_signal = 3'b000;

        #1;


        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Gain (Control = 7/8)", test_num);
        Vin = 8'd80;
        control_signal = 3'b111;

        #1;


        check_outputs(8'd70, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Input, Minimal Gain", test_num);
        Vin = 8'd8;
        control_signal = 3'b001;

        #1;


        check_outputs(8'd1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Input", test_num);
        Vin = 8'd0;
        control_signal = 3'b111;

        #1;


        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Integer Truncation Check", test_num);
        Vin = 8'd10;
        control_signal = 3'b001;

        #1;


        check_outputs(8'd1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Scale Input (255) at Half Gain", test_num);
        Vin = 8'd255;
        control_signal = 3'b100;

        #1;


        check_outputs(8'd127, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regulator Testbench");
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
        input expected_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h, ready=%b",
                         Vout, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h, ready=%b",
                         expected_Vout, expected_ready);
                $display("  Got:      Vout=%h, ready=%b",
                         Vout, ready);
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
