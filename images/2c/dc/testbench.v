`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Zero Input DC Response", test_num);
            rst = 1;
            x = 0;
            #20;
            rst = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum DC Input (Settling)", test_num);
            rst = 1;
            x = 0;
            #20;
            rst = 0;
            x = 4'd15;

            repeat(40) @(posedge clk);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range Step Response", test_num);
            rst = 1;
            x = 0;
            #20;
            rst = 0;
            repeat(5) @(posedge clk);
            x = 4'd8;
            repeat(40) @(posedge clk);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Response (Return to Zero)", test_num);
            rst = 1;
            x = 0;
            #20;
            rst = 0;
            @(posedge clk) x = 4'd12;
            @(posedge clk) x = 4'd0;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Frequency Attenuation (Averaging)", test_num);
            rst = 1;
            #20;
            rst = 0;
            repeat(30) begin
                @(posedge clk) x = 4'd14;
                @(posedge clk) x = 4'd0;
            end

            #1;


            check_outputs(4'd7);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
