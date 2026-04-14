`timescale 1ns/1ps

module fsm_module7_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    wire e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module7 dut (
        .clk(clk),
        .d(d),
        .e(e)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            d = 1;
            @(posedge clk);
            #1;
            if (e === 1'b1) begin

                @(negedge clk);
                d = 1;
                @(posedge clk);
                #1;
            end
            @(negedge clk);
            d = 0;
            $display("Circuit synchronized to state e=0");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Input d=1 for 1 cycle", test_num);
            @(negedge clk) d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Input d=1 for 2 cycles", test_num);
            @(negedge clk) d = 1;
            @(posedge clk);
            @(negedge clk) d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Input d=0 for 1 cycle", test_num);
            @(negedge clk) d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Input d=0 for 2 cycles", test_num);
            @(negedge clk) d = 0;
            @(posedge clk);
            @(negedge clk) d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Sequence d=1, d=0", test_num);
            @(negedge clk) d = 1;
            @(posedge clk);
            @(negedge clk) d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %03d: Sequence d=0, 1, 0, 1", test_num);
            @(negedge clk) d = 0; @(posedge clk);
            @(negedge clk) d = 1; @(posedge clk);
            @(negedge clk) d = 0; @(posedge clk);
            @(negedge clk) d = 1; @(posedge clk);
            #2;
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
        $display("fsm_module7 Testbench");
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
        input expected_e;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e)) begin
                $display("PASS");
                $display("  Outputs: e=%b",
                         e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%b",
                         expected_e);
                $display("  Got:      e=%b",
                         e);
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
        $dumpvars(0,clk, d, e);
    end

endmodule
