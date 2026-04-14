`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg Si;
    reg clk;
    reg reset;
    wire So;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .Si(Si),
        .clk(clk),
        .reset(reset),
        .So(So)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Si = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 1,0,0,0,0 - Expect So=1", test_num);
            reset_dut();
            Si = 1; @(posedge clk);
            Si = 0; @(posedge clk);
            Si = 0; @(posedge clk);
            Si = 0; @(posedge clk);
            Si = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 0,1,1,1,1 - Expect So=0", test_num);
            reset_dut();
            Si = 0; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 1,1,1,1,1 - Expect So=1", test_num);
            reset_dut();
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during operation - Expect So=0", test_num);
            reset_dut();
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            reset = 1; @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in pattern 10110 - Expect So=1", test_num);
            reset_dut();
            Si = 1; @(posedge clk);
            Si = 0; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 1; @(posedge clk);
            Si = 0; @(posedge clk);
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
        $display("SISO_Shift_Register Testbench");
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
        input expected_So;
        begin
            if (expected_So === (expected_So ^ So ^ expected_So)) begin
                $display("PASS");
                $display("  Outputs: So=%b",
                         So);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: So=%b",
                         expected_So);
                $display("  Got:      So=%b",
                         So);
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
        $dumpvars(0,Si, clk, reset, So);
    end

endmodule
