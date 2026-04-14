`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .a(a),
        .b(b),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Testing AND logic (0,0)", test_num);
        a = 0; b = 0;
        #20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Testing AND logic (1,1)", test_num);
        a = 1; b = 1;
        #20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Testing AND logic (0,1)", test_num);
        a = 0; b = 1;
        #20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Testing AND logic (1,0)", test_num);
        a = 1; b = 0;
        #20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Glitch on input 'a' (1->0->1)", test_num);
        a = 1; b = 1; #20;


        a = 0; #1;
        a = 1;

        #20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Simultaneous input transition (1,0 to 0,1)", test_num);
        a = 1; b = 0; #20;


        a = 0;
        #1;
        b = 1;

        #20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Recovery after multiple fluctuations", test_num);
        a = 1; b = 1; #20;


        a = 0; b = 0; #2;
        a = 1; b = 0; #2;
        a = 0; b = 1; #2;


        a = 0; b = 0;
        #20;
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
        $display("hazard_detection Testbench");
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
        input expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%b",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%b",
                         expected_output_signal);
                $display("  Got:      output_signal=%b",
                         output_signal);
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
