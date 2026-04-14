`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    wire [15:0] dac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .ctrl(ctrl),
        .dac_out(dac_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum level (ctrl = 4'h0)", test_num);
        ctrl = 4'h0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum level (ctrl = 4'hF)", test_num);
        ctrl = 4'hF;
        #1;

        check_outputs(16'hF000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Level 1 (ctrl = 4'h1)", test_num);
        ctrl = 4'h1;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Level 2 (ctrl = 4'h2)", test_num);
        ctrl = 4'h2;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-point (ctrl = 4'h8)", test_num);
        ctrl = 4'h8;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Level 4 (ctrl = 4'h4)", test_num);
        ctrl = 4'h4;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern A (ctrl = 4'hA)", test_num);
        ctrl = 4'hA;
        #1;

        check_outputs(16'hA000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 5 (ctrl = 4'h5)", test_num);
        ctrl = 4'h5;
        #1;

        check_outputs(16'h5000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
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
        input [15:0] expected_dac_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dac_out === (expected_dac_out ^ dac_out ^ expected_dac_out)) begin
                $display("PASS");
                $display("  Outputs: dac_out=%h",
                         dac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_out=%h",
                         expected_dac_out);
                $display("  Got:      dac_out=%h",
                         dac_out);
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
