`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] V_control;
    reg clk;
    wire [15:0] F_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .V_control(V_control),
        .clk(clk),
        .F_out(F_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            V_control = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: V_control = 0 (Min)", test_num);
            reset_dut();
            V_control = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: V_control = 15 (Max)", test_num);
            reset_dut();
            V_control = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: V_control = 5", test_num);
            reset_dut();
            V_control = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: V_control = 10", test_num);
            reset_dut();
            V_control = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: V_control = 1", test_num);
            reset_dut();
            V_control = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
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
        input [15:0] expected_F_out;
        begin
            if (expected_F_out === (expected_F_out ^ F_out ^ expected_F_out)) begin
                $display("PASS");
                $display("  Outputs: F_out=%h",
                         F_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F_out=%h",
                         expected_F_out);
                $display("  Got:      F_out=%h",
                         F_out);
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
        $dumpvars(0,V_control, clk, F_out);
    end

endmodule
