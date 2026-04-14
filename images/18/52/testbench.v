`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_signal;
    wire [4:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: System Reset", test_num);
        rst_n = 0;
        in_signal = 5'h1F;
        repeat(2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 1-Cycle Glitch Rejection", test_num);

        rst_n = 0; in_signal = 5'h00; @(posedge clk); rst_n = 1; @(posedge clk);

        in_signal = 5'h01;
        @(posedge clk);
        in_signal = 5'h00;
        repeat(3) @(posedge clk);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stable 2-Cycle Transition", test_num);
        rst_n = 0; in_signal = 5'h00; @(posedge clk); rst_n = 1; @(posedge clk);

        in_signal = 5'h12;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mixed Glitch and Stability", test_num);

        rst_n = 1; in_signal = 5'h12; repeat(2) @(posedge clk);

        in_signal = 5'h1F;
        @(posedge clk);
        in_signal = 5'h12;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stable Transition to Zero", test_num);

        in_signal = 5'h1F; repeat(2) @(posedge clk);

        in_signal = 5'h00;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential Rapid Changes", test_num);
        rst_n = 0; in_signal = 5'h00; @(posedge clk); rst_n = 1; @(posedge clk);

        in_signal = 5'h01; @(posedge clk);
        in_signal = 5'h02; @(posedge clk);
        in_signal = 5'h04; @(posedge clk);
        in_signal = 5'h08; @(posedge clk);
        in_signal = 5'h10;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(5'h10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
