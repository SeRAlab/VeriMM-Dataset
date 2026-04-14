`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [4:0] x;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .clk(clk),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input (Steady State)", test_num);


            x = 5'd0;
            repeat(20) @(posedge clk);


            @(negedge clk);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DC Mid-scale Input (16)", test_num);


            x = 5'd0;
            repeat(10) @(posedge clk);


            x = 5'd16;
            repeat(40) @(posedge clk);


            @(negedge clk);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DC Full-scale Input (31)", test_num);


            x = 5'd0;
            repeat(10) @(posedge clk);


            x = 5'd31;
            repeat(50) @(posedge clk);


            @(negedge clk);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Recovery", test_num);


            x = 5'd0;
            repeat(10) @(posedge clk);


            x = 5'd30;
            @(posedge clk);


            x = 5'd0;
            repeat(40) @(posedge clk);


            @(negedge clk);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Step Input (5)", test_num);


            x = 5'd0;
            repeat(10) @(posedge clk);


            x = 5'd5;
            repeat(30) @(posedge clk);


            @(negedge clk);
            #1;

            check_outputs(5'd5);
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
        input [4:0] expected_y;
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
