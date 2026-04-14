`timescale 1ns/1ps

module fsm_module7_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    wire u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module7 dut (
        .clk(clk),
        .d(d),
        .u(u)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;


            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial d=0 transition", test_num);
            reset_dut();
            d = 0;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=0, 0 sequence", test_num);
            reset_dut();
            d = 0; @(posedge clk);
            d = 0; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=1 transition", test_num);
            reset_dut();
            d = 1;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=1, 1 sequence", test_num);
            reset_dut();
            d = 1; @(posedge clk);
            d = 1; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=1, 0 sequence (De-phasing Q0/Q3)", test_num);
            reset_dut();
            d = 1; @(posedge clk);
            d = 0; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=0, 1 sequence", test_num);
            reset_dut();
            d = 0; @(posedge clk);
            d = 1; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=0, 1, 0, 1 sequence", test_num);
            reset_dut();
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: d=1, 1, 0, 0 sequence", test_num);
            reset_dut();
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk); #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_module7 Testbench");
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
        input expected_u;
        begin
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%b",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b",
                         expected_u);
                $display("  Got:      u=%b",
                         u);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, d, u);
    end

endmodule
