`timescale 1ns/1ps

module ldo_regulator_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] v_fb;
    reg [7:0] v_ref;
    wire control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ldo_regulator dut (
        .enable(enable),
        .v_fb(v_fb),
        .v_ref(v_ref),
        .control(control)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LDO Disabled", test_num);
            enable = 0;
            v_ref = 8'd128;
            v_fb = 8'd50;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled, v_fb < v_ref", test_num);
            enable = 1;
            v_ref = 8'd128;
            v_fb = 8'd100;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled, v_fb > v_ref", test_num);
            enable = 1;
            v_ref = 8'd128;
            v_fb = 8'd150;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled, v_fb == v_ref", test_num);
            enable = 1;
            v_ref = 8'd128;
            v_fb = 8'd128;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary - Zero Reference", test_num);
            enable = 1;
            v_ref = 8'd0;
            v_fb = 8'd10;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Reference, Low Feedback", test_num);
            enable = 1;
            v_ref = 8'hFF;
            v_fb = 8'h01;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle Enable with v_fb < v_ref", test_num);
            v_ref = 8'd200;
            v_fb = 8'd100;

            enable = 0;
            #5;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ldo_regulator Testbench");
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
        input expected_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%b",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%b",
                         expected_control);
                $display("  Got:      control=%b",
                         control);
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
