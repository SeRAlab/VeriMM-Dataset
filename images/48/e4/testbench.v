`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 1;
            #2;
            reset_n = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: 1 Clock Cycle (Fill 1)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: 4 Clock Cycles (Partial Fill)", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 8 Clock Cycles (Full Fill)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: 9 Clock Cycles (Begin Clear)", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: 12 Clock Cycles (Partial Clear)", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: 15 Clock Cycles (Almost Clear)", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: 16 Clock Cycles (Wrap Around to 0)", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: 17 Clock Cycles (Sequence Repeat Check)", test_num);
            reset_dut();
            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset_n, out);
    end

endmodule
