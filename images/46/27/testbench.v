`timescale 1ns/1ps

module fsm_module5_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg clk;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module5 dut (
        .c(c),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            c = 1;
            @(posedge clk);
            c = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Initial state check (0,0)", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single cycle c=1", test_num);
            reset_dut();
            c = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single cycle c=0", test_num);
            reset_dut();
            c = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sustained c=1 (5 cycles)", test_num);
            reset_dut();
            repeat(5) begin
                c = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sustained c=0 (5 cycles)", test_num);
            reset_dut();
            repeat(5) begin
                c = 0;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating c (1010)", test_num);
            reset_dut();
            c = 1; @(posedge clk);
            c = 0; @(posedge clk);
            c = 1; @(posedge clk);
            c = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequence 11001", test_num);
            reset_dut();
            c = 1; @(posedge clk);
            c = 1; @(posedge clk);
            c = 0; @(posedge clk);
            c = 0; @(posedge clk);
            c = 1; @(posedge clk);
            #1;
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
        $display("fsm_module5 Testbench");
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
        input expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%b",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b",
                         expected_p);
                $display("  Got:      p=%b",
                         p);
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
        $dumpvars(0,c, clk, p);
    end

endmodule
