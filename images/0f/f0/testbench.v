`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_in;
    wire [4:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero Input", test_num);
        signal_in = 5'd0;

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Unit Input", test_num);
        signal_in = 5'd1;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Mid-range Input (16)", test_num);
        signal_in = 5'd16;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum Input (31)", test_num);
        signal_in = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits 01010", test_num);
        signal_in = 5'b01010;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits 10101", test_num);
        signal_in = 5'b10101;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Random Value (7)", test_num);
        signal_in = 5'd7;
        #1;

        check_outputs(5'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Random Value (23)", test_num);
        signal_in = 5'd23;
        #1;

        check_outputs(5'd23);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("butterworth_filter Testbench");
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
        input [4:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
