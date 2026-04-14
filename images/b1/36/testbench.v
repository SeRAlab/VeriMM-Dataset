`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .areset(areset),
        .clk(clk),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            #12;
            areset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Increment Check (10 cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Wrap-around Check (256 cycles)", test_num);
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Asynchronous Reset Mid-cycle", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #3;
            areset = 1;
            #2;
            #1;

            check_outputs(8'd0);
            areset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Post-Wrap-around Check", test_num);
            reset_dut();
            repeat(258) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,areset, clk, q);
    end

endmodule
