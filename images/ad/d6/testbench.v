`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg s_in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .s_in(s_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s_in = 0;
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Shifting in 4'b1111", test_num);
            reset_dut();
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shifting in 4'b1010 (Sequence: 1, 0, 1, 0)", test_num);
            reset_dut();
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 0;
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shifting in 4'b0001 (Sequence: 0, 0, 0, 1)", test_num);
            reset_dut();
            @(negedge clk) s_in = 0;
            @(negedge clk) s_in = 0;
            @(negedge clk) s_in = 0;
            @(negedge clk) s_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overflow Test - Shifting 8 bits (1111_0110)", test_num);
            reset_dut();

            repeat(4) @(negedge clk) s_in = 1;

            @(negedge clk) s_in = 0;
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 1;
            @(negedge clk) s_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Reset verification", test_num);

            @(negedge clk) s_in = 1;
            repeat(3) @(negedge clk);

            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, s_in, q);
    end

endmodule
