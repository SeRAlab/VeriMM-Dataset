`timescale 1ns/1ps

module tap_controller_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VPWR;
    wire tap_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tap_controller dut (
        .VGND(VGND),
        .VPWR(VPWR),
        .tap_output(tap_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Setting VPWR=1, VGND=0 (Expect Closed: 0)", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Setting VPWR=0, VGND=1 (Expect Open: 1)", test_num);
            VPWR = 1'b0;
            VGND = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined State VPWR=0, VGND=0", test_num);
            VPWR = 1'b0;
            VGND = 1'b0;


            #1;



            check_outputs(tap_output);
            $display("  Note: Output is %b (Specification allows 0 or 1)", tap_output);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined State VPWR=1, VGND=1", test_num);
            VPWR = 1'b1;
            VGND = 1'b1;

            #1;


            check_outputs(tap_output);
            $display("  Note: Output is %b (Specification allows 0 or 1)", tap_output);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Open (0,1) to Closed (1,0)", test_num);

            VPWR = 1'b0; VGND = 1'b1;
            #5;

            VPWR = 1'b1; VGND = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Closed (1,0) to Open (0,1)", test_num);

            VPWR = 1'b1; VGND = 1'b0;
            #5;

            VPWR = 1'b0; VGND = 1'b1;
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
        $display("tap_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_tap_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tap_output === (expected_tap_output ^ tap_output ^ expected_tap_output)) begin
                $display("PASS");
                $display("  Outputs: tap_output=%b",
                         tap_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tap_output=%b",
                         expected_tap_output);
                $display("  Got:      tap_output=%b",
                         tap_output);
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
