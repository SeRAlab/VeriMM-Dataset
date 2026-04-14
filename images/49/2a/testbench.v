`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    reg photo;
    wire light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .photo(photo),
        .light(light)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo Low (Dark), Ctrl Min", test_num);
            photo = 1'b0;
            ctrl = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo Low (Dark), Ctrl Max", test_num);
            photo = 1'b0;
            ctrl = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo High (Bright), Ctrl Max (1.0 scale)", test_num);
            photo = 1'b1;
            ctrl = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo High (Bright), Ctrl Min (0.0 scale)", test_num);
            photo = 1'b1;
            ctrl = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo High (Bright), Ctrl Mid-High (0.53 scale)", test_num);
            photo = 1'b1;
            ctrl = 4'b1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo High (Bright), Ctrl Mid-Low (0.46 scale)", test_num);
            photo = 1'b1;
            ctrl = 4'b0111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Photo Low (Dark), Ctrl Mid", test_num);
            photo = 1'b0;
            ctrl = 4'b1010;
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
        $display("top_module Testbench");
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
        input expected_light;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_light === (expected_light ^ light ^ expected_light)) begin
                $display("PASS");
                $display("  Outputs: light=%b",
                         light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light=%b",
                         expected_light);
                $display("  Got:      light=%b",
                         light);
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
