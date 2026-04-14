`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] V_in;
    reg [7:0] V_ref;
    wire PWM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .V_in(V_in),
        .V_ref(V_ref),
        .PWM(PWM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: V_in < V_ref (50 < 100)", test_num);
        V_in = 8'd50;
        V_ref = 8'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: V_in > V_ref (200 > 100)", test_num);
        V_in = 8'd200;
        V_ref = 8'd100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: V_in == V_ref (128 == 128)", test_num);
        V_in = 8'd128;
        V_ref = 8'd128;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Min V_in, Max V_ref (0 < 255)", test_num);
        V_in = 8'd0;
        V_ref = 8'd255;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max V_in, Min V_ref (255 > 0)", test_num);
        V_in = 8'd255;
        V_ref = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: V_in = V_ref + 1", test_num);
        V_ref = 8'd10;
        V_in = 8'd11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: V_in = V_ref - 1", test_num);
        V_ref = 8'd10;
        V_in = 8'd9;
        #1;

        check_outputs(1'b0);
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
        input expected_PWM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PWM === (expected_PWM ^ PWM ^ expected_PWM)) begin
                $display("PASS");
                $display("  Outputs: PWM=%b",
                         PWM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM=%b",
                         expected_PWM);
                $display("  Got:      PWM=%b",
                         PWM);
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
