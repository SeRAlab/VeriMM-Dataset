`timescale 1ns/1ps

module power_mgmt_tb;

    // Testbench signals (combinational circuit)
    reg sleep;
    reg vgnd;
    reg vpwr;
    wire pwrgood;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_mgmt dut (
        .sleep(sleep),
        .vgnd(vgnd),
        .vpwr(vpwr),
        .pwrgood(pwrgood)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Operation (sleep=0, vpwr=1, vgnd=1)", test_num);
            sleep = 1'b0;
            vpwr  = 1'b1;
            vgnd  = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sleep Mode Active (sleep=1, vpwr=1, vgnd=1)", test_num);
            sleep = 1'b1;
            vpwr  = 1'b1;
            vgnd  = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Loss (sleep=0, vpwr=0, vgnd=1)", test_num);
            sleep = 1'b0;
            vpwr  = 1'b0;
            vgnd  = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ground Loss (sleep=0, vpwr=1, vgnd=0)", test_num);
            sleep = 1'b0;
            vpwr  = 1'b1;
            vgnd  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Low", test_num);
            sleep = 1'b0;
            vpwr  = 1'b0;
            vgnd  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sleep with Power Loss", test_num);
            sleep = 1'b1;
            vpwr  = 1'b0;
            vgnd  = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sleep with Ground Loss", test_num);
            sleep = 1'b1;
            vpwr  = 1'b1;
            vgnd  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ground only", test_num);
            sleep = 1'b0;
            vpwr  = 1'b0;
            vgnd  = 1'b1;
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
        $display("power_mgmt Testbench");
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
        input expected_pwrgood;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pwrgood === (expected_pwrgood ^ pwrgood ^ expected_pwrgood)) begin
                $display("PASS");
                $display("  Outputs: pwrgood=%b",
                         pwrgood);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwrgood=%b",
                         expected_pwrgood);
                $display("  Got:      pwrgood=%b",
                         pwrgood);
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
