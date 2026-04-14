`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] V_fb;
    reg [7:0] V_ref;
    wire V_ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .V_fb(V_fb),
        .V_ref(V_ref),
        .V_ctrl(V_ctrl)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: V_ref > V_fb (Reference higher than feedback)", test_num);
            V_ref = 8'd150;
            V_fb  = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: V_ref < V_fb (Overshoot - feedback higher than reference)", test_num);
            V_ref = 8'd100;
            V_fb  = 8'd150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: V_ref == V_fb (Equilibrium state)", test_num);
            V_ref = 8'd128;
            V_fb  = 8'd128;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary - Maximum Reference and Minimum Feedback", test_num);
            V_ref = 8'd255;
            V_fb  = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary - Minimum Reference and Maximum Feedback", test_num);
            V_ref = 8'd0;
            V_fb  = 8'd255;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Small difference (V_ref = V_fb + 1)", test_num);
            V_ref = 8'd201;
            V_fb  = 8'd200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Small difference (V_ref = V_fb - 1)", test_num);
            V_ref = 8'd199;
            V_fb  = 8'd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Both inputs at zero", test_num);
            V_ref = 8'd0;
            V_fb  = 8'd0;
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
        $display("LDO_Regulator Testbench");
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
        input expected_V_ctrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V_ctrl === (expected_V_ctrl ^ V_ctrl ^ expected_V_ctrl)) begin
                $display("PASS");
                $display("  Outputs: V_ctrl=%b",
                         V_ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V_ctrl=%b",
                         expected_V_ctrl);
                $display("  Got:      V_ctrl=%b",
                         V_ctrl);
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
