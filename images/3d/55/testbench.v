`timescale 1ns/1ps

module d_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_flip_flop dut (
        .D(D),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        D = 4'b0000;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power-on Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load value 4'hA on rising edge", test_num);
        reset_dut();
        D = 4'hA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load value 4'hF and verify all bits", test_num);
        reset_dut();
        D = 4'hF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Asynchronous reset mid-clock cycle", test_num);
        reset_dut();
        D = 4'h5;
        @(posedge clk);
        #2;
        reset = 1;
        #2;
        #1;

        check_outputs(4'h0);
        reset = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify edge-triggered behavior (No change on falling edge)", test_num);
        reset_dut();
        D = 4'h3;
        @(posedge clk);
        #2;
        @(negedge clk);
        D = 4'hC;
        #2;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential data loading over multiple cycles", test_num);
        reset_dut();
        D = 4'h1;
        @(posedge clk);
        #1;
        D = 4'h2;
        @(posedge clk);
        #1;
        D = 4'h4;
        @(posedge clk);
        #1;
        D = 4'h8;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset priority over data input at clock edge", test_num);
        reset_dut();
        D = 4'hB;
        reset = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_flip_flop Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, reset, Q);
    end

endmodule
