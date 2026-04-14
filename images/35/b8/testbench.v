`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] signal_in;
    wire [9:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Minimum Input (0)", test_num);
        signal_in = 10'd0;

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input below threshold (256)", test_num);
        signal_in = 10'd256;

        #1;


        check_outputs(10'd256);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input at threshold (512)", test_num);
        signal_in = 10'd512;

        #1;


        check_outputs(10'd512);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input slightly above threshold (520)", test_num);
        signal_in = 10'd520;

        #1;


        check_outputs(10'd516);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: High amplitude input (800)", test_num);
        signal_in = 10'd800;

        #1;


        check_outputs(10'd656);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum 10-bit input (1023)", test_num);
        signal_in = 10'd1023;

        #1;


        check_outputs(10'd767);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Signal drop from high to low", test_num);
        signal_in = 10'd900;
        #5;
        signal_in = 10'd100;

        #1;


        check_outputs(10'd100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [9:0] expected_signal_out;
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
