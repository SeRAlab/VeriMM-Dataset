`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg enable;
    wire [3:0] gated_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .data(data),
        .enable(enable),
        .gated_data(gated_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power Gating Active (Enable=0), Data non-zero", test_num);
            enable = 1'b0;
            data = 4'hA;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Power On (Enable=1), Data non-zero", test_num);
            enable = 1'b1;
            data = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Power On (Enable=1), Data all ones", test_num);
            enable = 1'b1;
            data = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Power Gating Active (Enable=0), Data all ones", test_num);
            enable = 1'b0;
            data = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Power On (Enable=1), Data all zeros", test_num);
            enable = 1'b1;
            data = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Power On (Enable=1), Alternating bit pattern", test_num);
            enable = 1'b1;
            data = 4'h5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switch from Enabled to Gated with same data", test_num);

            enable = 1'b1;
            data = 4'hC;
            #5;

            enable = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
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
        input [3:0] expected_gated_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_data === (expected_gated_data ^ gated_data ^ expected_gated_data)) begin
                $display("PASS");
                $display("  Outputs: gated_data=%h",
                         gated_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_data=%h",
                         expected_gated_data);
                $display("  Got:      gated_data=%h",
                         gated_data);
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
