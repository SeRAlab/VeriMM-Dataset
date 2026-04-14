`timescale 1ns/1ps

module bluetooth_signal_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] signal_strength_a;
    reg [7:0] signal_strength_b;
    wire [1:0] strongest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_signal_comparator dut (
        .signal_strength_a(signal_strength_a),
        .signal_strength_b(signal_strength_b),
        .strongest(strongest)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A is stronger (100 > 50)", test_num);
            signal_strength_a = 8'd100;
            signal_strength_b = 8'd50;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: B is stronger (30 < 90)", test_num);
            signal_strength_a = 8'd30;
            signal_strength_b = 8'd90;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signals are equal (128 == 128)", test_num);
            signal_strength_a = 8'd128;
            signal_strength_b = 8'd128;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A at max, B at min (255 > 0)", test_num);
            signal_strength_a = 8'hFF;
            signal_strength_b = 8'h00;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: B at max, A at min (0 < 255)", test_num);
            signal_strength_a = 8'h00;
            signal_strength_b = 8'hFF;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both signals at maximum (255 == 255)", test_num);
            signal_strength_a = 8'hFF;
            signal_strength_b = 8'hFF;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both signals at minimum (0 == 0)", test_num);
            signal_strength_a = 8'h00;
            signal_strength_b = 8'h00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Precision check (129 > 128)", test_num);
            signal_strength_a = 8'd129;
            signal_strength_b = 8'd128;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Precision check (127 < 128)", test_num);
            signal_strength_a = 8'd127;
            signal_strength_b = 8'd128;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_signal_comparator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_strongest;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strongest === (expected_strongest ^ strongest ^ expected_strongest)) begin
                $display("PASS");
                $display("  Outputs: strongest=%h",
                         strongest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strongest=%h",
                         expected_strongest);
                $display("  Got:      strongest=%h",
                         strongest);
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
