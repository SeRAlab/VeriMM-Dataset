`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Control high, data pass-through (8'hA5)", test_num);
        control = 1'b1;
        data_in = 8'hA5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Control low, data gated (8'hA5 input)", test_num);
        control = 1'b0;
        data_in = 8'hA5;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Control high, all ones pass-through", test_num);
        control = 1'b1;
        data_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Control low, all ones gated", test_num);
        control = 1'b0;
        data_in = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Control high, zero pass-through", test_num);
        control = 1'b1;
        data_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Control low, zero input", test_num);
        control = 1'b0;
        data_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Control high, alternating bits (8'h55)", test_num);
        control = 1'b1;
        data_in = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Control high, alternating bits (8'hAA)", test_num);
        control = 1'b1;
        data_in = 8'hAA;
        #1;

        check_outputs(8'hAA);
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
