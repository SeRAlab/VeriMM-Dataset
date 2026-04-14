`timescale 1ns/1ps

module decoder1to2_tb;

    // Testbench signals (combinational circuit)
    reg bin;
    wire [1:0] onehot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder1to2 dut (
        .bin(bin),
        .onehot(onehot)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input bin = 0", test_num);
            bin = 1'b0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input bin = 1", test_num);
            bin = 1'b1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder1to2 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        
        
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
        input [1:0] expected_onehot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_onehot === (expected_onehot ^ onehot ^ expected_onehot)) begin
                $display("PASS");
                $display("  Outputs: onehot=%h",
                         onehot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: onehot=%h",
                         expected_onehot);
                $display("  Got:      onehot=%h",
                         onehot);
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
