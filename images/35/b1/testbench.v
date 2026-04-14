`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vfb;
    reg [7:0] Vref;
    reg enable;
    wire PWM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .Vfb(Vfb),
        .Vref(Vref),
        .enable(enable),
        .PWM_out(PWM_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PWM disabled (enable=0, Vref > Vfb)", test_num);
            enable = 0;
            Vref = 8'd200;
            Vfb = 8'd100;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PWM enabled, Demand High (Vref > Vfb)", test_num);
            enable = 1;
            Vref = 8'd200;
            Vfb = 8'd100;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PWM enabled, Demand Low (Vref < Vfb)", test_num);
            enable = 1;
            Vref = 8'd50;
            Vfb = 8'd150;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PWM enabled, Zero Error (Vref == Vfb)", test_num);
            enable = 1;
            Vref = 8'd128;
            Vfb = 8'd128;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Reference (Vref=255, Vfb=0)", test_num);
            enable = 1;
            Vref = 8'hFF;
            Vfb = 8'h00;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Feedback (Vref=100, Vfb=255)", test_num);
            enable = 1;
            Vref = 8'd100;
            Vfb = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disable signal during high demand", test_num);
            enable = 1;
            Vref = 8'd250;
            Vfb = 8'd10;
            #5;
            enable = 0;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary condition - minimal difference (Vref > Vfb)", test_num);
            enable = 1;
            Vref = 8'd129;
            Vfb = 8'd128;
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
        $display("switching_regulator Testbench");
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
        input expected_PWM_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PWM_out === (expected_PWM_out ^ PWM_out ^ expected_PWM_out)) begin
                $display("PASS");
                $display("  Outputs: PWM_out=%b",
                         PWM_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM_out=%b",
                         expected_PWM_out);
                $display("  Got:      PWM_out=%b",
                         PWM_out);
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
