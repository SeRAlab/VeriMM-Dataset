`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] h_prev;
    reg [4:0] x;
    wire [4:0] h_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .h_prev(h_prev),
        .x(x),
        .h_new(h_new)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Zero Initialization", test_num);
        x = 5'd0;
        h_prev = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Small values (No Saturation)", test_num);
        x = 5'd4;
        h_prev = 5'd6;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Addition reaching maximum limit", test_num);
        x = 5'd15;
        h_prev = 5'd16;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Saturating Activation (Overflow check)", test_num);
        x = 5'd20;
        h_prev = 5'd20;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Previous state at max, input at zero", test_num);
        x = 5'd0;
        h_prev = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Input at max, previous state at zero", test_num);
        x = 5'd31;
        h_prev = 5'd0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Extreme Saturation", test_num);
        x = 5'd31;
        h_prev = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Small increment check", test_num);
        x = 5'd1;
        h_prev = 5'd1;
        #1;

        check_outputs(5'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [4:0] expected_h_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_new === (expected_h_new ^ h_new ^ expected_h_new)) begin
                $display("PASS");
                $display("  Outputs: h_new=%h",
                         h_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_new=%h",
                         expected_h_new);
                $display("  Got:      h_new=%h",
                         h_new);
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
