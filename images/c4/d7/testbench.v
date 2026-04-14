`timescale 1ns/1ps

module control_reg_block_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    wire [1:0] en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    control_reg_block dut (
        .ctrl(ctrl),
        .en(en)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All control signals 0", test_num);
        ctrl = 4'b0000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Control signals 0 and 1 high", test_num);
        ctrl = 4'b0011;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Control signals 2 and 3 high", test_num);
        ctrl = 4'b1100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All control signals high", test_num);
        ctrl = 4'b1111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Partial activation 1010", test_num);
        ctrl = 4'b1010;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Partial activation 0101", test_num);
        ctrl = 4'b0101;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Single bit ctrl[3] active", test_num);
        ctrl = 4'b1000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Single bit ctrl[0] active", test_num);
        ctrl = 4'b0001;
        #1;

        check_outputs(2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("control_reg_block Testbench");
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
        input [1:0] expected_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: en=%h",
                         en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%h",
                         expected_en);
                $display("  Got:      en=%h",
                         en);
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
