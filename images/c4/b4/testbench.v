`timescale 1ns/1ps

module counter_tb_tb;

    // Testbench signals (combinational circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_tb dut (

    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count to 5", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            enable = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
            enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable/Pause Check", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            enable = 1;
            repeat(3) @(posedge clk);
            #1 enable = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap-around Check", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            enable = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
            enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Check", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            enable = 1;
            repeat(15) @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
            enable = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-count Reset Check", test_num);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            enable = 1;
            repeat(7) @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
            reset = 0;
            enable = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_tb Testbench");
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
