`timescale 1ns/1ps

module ButterworthFilter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_in;
    wire [4:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ButterworthFilter dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task apply_reset;

    begin
        rst = 1;
        signal_in = 5'd0;
        repeat(5) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Zero Input", test_num);
        apply_reset();

        signal_in = 5'd0;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: DC Step Response (Value: 16)", test_num);
        apply_reset();

        signal_in = 5'd16;
        repeat(50) @(posedge clk);

        #1;


        check_outputs(5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: DC Step Response (Value: 25)", test_num);
        apply_reset();

        signal_in = 5'd25;
        repeat(50) @(posedge clk);

        #1;


        check_outputs(5'd25);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High to Low Transition", test_num);
        apply_reset();


        signal_in = 5'd30;
        repeat(40) @(posedge clk);


        signal_in = 5'd10;
        repeat(60) @(posedge clk);

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High Frequency Signal (Avg: 10)", test_num);
        apply_reset();

        repeat(30) begin
            signal_in = 5'd0;
            @(posedge clk);
            signal_in = 5'd20;
            @(posedge clk);
        end




        #1;





        check_outputs(5'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ButterworthFilter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
