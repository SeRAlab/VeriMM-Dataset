`timescale 1ns/1ps

module dac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] data_in;
    wire [7:0] ctrl_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_controller dut (
        .data_in(data_in),
        .ctrl_out(ctrl_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Value", test_num);
        data_in = 24'h000000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Value", test_num);
        data_in = 24'hFFFFFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range value (MSB toggled)", test_num);
        data_in = 24'h800000;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower 16 bits set to 1", test_num);
        data_in = 24'h00FFFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 17th bit set", test_num);
        data_in = 24'h010000;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating pattern 0xA5", test_num);
        data_in = 24'hA5A5A5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 0x123456", test_num);
        data_in = 24'h123456;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper byte boundaries", test_num);
        data_in = 24'hFE0000;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_controller Testbench");
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
        input [7:0] expected_ctrl_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ctrl_out === (expected_ctrl_out ^ ctrl_out ^ expected_ctrl_out)) begin
                $display("PASS");
                $display("  Outputs: ctrl_out=%h",
                         ctrl_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl_out=%h",
                         expected_ctrl_out);
                $display("  Got:      ctrl_out=%h",
                         ctrl_out);
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
