`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg data_in0;
    reg data_in1;
    reg sel;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .sel(sel),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select 0 - Route data_in0 (0) to output", test_num);
            sel = 1'b0;
            data_in0 = 1'b0;
            data_in1 = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select 0 - Route data_in0 (1) to output", test_num);
            sel = 1'b0;
            data_in0 = 1'b1;
            data_in1 = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select 1 - Route data_in1 (0) to output", test_num);
            sel = 1'b1;
            data_in0 = 1'b1;
            data_in1 = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select 1 - Route data_in1 (1) to output", test_num);
            sel = 1'b1;
            data_in0 = 1'b0;
            data_in1 = 1'b1;

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
        $display("mux_2to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
