`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] vin;
    wire [3:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .control(control),
        .vin(vin),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin below threshold (Vin=2.4V, Expected=0V)", test_num);
            vin = 4'd8;
            control = 2'b00;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin just below threshold (Vin=3.3V, Expected=0V)", test_num);
            vin = 4'd11;
            control = 2'b11;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin at threshold, Ctrl=00 (Selected=1.2V)", test_num);
            vin = 4'd12;
            control = 2'b00;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin at threshold, Ctrl=01 (Selected=1.5V)", test_num);
            vin = 4'd12;
            control = 2'b01;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin at threshold, Ctrl=10 (Selected=1.8V)", test_num);
            vin = 4'd12;
            control = 2'b10;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vin at threshold, Ctrl=11 (Selected=3.3V)", test_num);
            vin = 4'd12;
            control = 2'b11;
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Vin, Ctrl=01 (Selected=1.5V)", test_num);
            vin = 4'd15;
            control = 2'b01;
            #1;

            check_outputs(4'd5);
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
        input [3:0] expected_vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
