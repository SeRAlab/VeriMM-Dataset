`timescale 1ns/1ps

module binary_counter_cout_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire cout;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_cout dut (
        .clk(clk),
        .reset(reset),
        .cout(cout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Increment to 4", test_num);
            reset_dut();
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Reaching Maximum Value 7", test_num);
            reset_dut();
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Rollover (8 cycles)", test_num);
            reset_dut();
            repeat (8) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: State After Rollover", test_num);
            reset_dut();
            repeat (9) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Rollovers (16 cycles)", test_num);
            reset_dut();
            repeat (16) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();
            repeat (5) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_cout Testbench");
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
        input expected_cout;
        input [2:0] expected_q;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, q=%h",
                         cout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, q=%h",
                         expected_cout, expected_q);
                $display("  Got:      cout=%b, q=%h",
                         cout, q);
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
        $dumpvars(0,clk, reset, cout, q);
    end

endmodule
