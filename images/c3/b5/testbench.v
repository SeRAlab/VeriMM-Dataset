`timescale 1ns/1ps

module ChooseModule_tb;

    // Testbench signals (combinational circuit)
    reg io_ready;
    reg io_valid_0;
    wire io_chosen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ChooseModule dut (
        .io_ready(io_ready),
        .io_valid_0(io_valid_0),
        .io_chosen(io_chosen)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: io_ready=1, io_valid_0=1 (Expect io_chosen=0)", test_num);
            io_ready = 1'b1;
            io_valid_0 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: io_ready=1, io_valid_0=0 (Expect io_chosen=1)", test_num);
            io_ready = 1'b1;
            io_valid_0 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: io_ready=0, io_valid_0=1 (Expect io_chosen=0 - Gated)", test_num);
            io_ready = 1'b0;
            io_valid_0 = 1'b1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: io_ready=0, io_valid_0=0 (Expect io_chosen=0 - Gated)", test_num);
            io_ready = 1'b0;
            io_valid_0 = 1'b0;
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
        $display("ChooseModule Testbench");
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
        input expected_io_chosen;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_chosen === (expected_io_chosen ^ io_chosen ^ expected_io_chosen)) begin
                $display("PASS");
                $display("  Outputs: io_chosen=%b",
                         io_chosen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_chosen=%b",
                         expected_io_chosen);
                $display("  Got:      io_chosen=%b",
                         io_chosen);
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
