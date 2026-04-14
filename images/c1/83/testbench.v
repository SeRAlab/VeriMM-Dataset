`timescale 1ns/1ps

module bw_mckbuf_11x_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg rclk;
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_mckbuf_11x dut (
        .en(en),
        .rclk(rclk),
        .clk(clk)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logic check - en=0, rclk=0 (Gating Active)", test_num);
            en = 1'b0;
            rclk = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logic check - en=0, rclk=1 (Gating Active)", test_num);
            en = 1'b0;
            rclk = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logic check - en=1, rclk=0 (Transparent)", test_num);
            en = 1'b1;
            rclk = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logic check - en=1, rclk=1 (Transparent)", test_num);
            en = 1'b1;
            rclk = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition check - en low to high while rclk is high", test_num);
            rclk = 1'b1;
            en = 1'b0;
            #10;
            en = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition check - en high to low while rclk is high", test_num);
            rclk = 1'b1;
            en = 1'b1;
            #10;
            en = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_mckbuf_11x Testbench");
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
        input expected_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
