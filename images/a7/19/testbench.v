`timescale 1ns/1ps

module digital_lock_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] code;
    reg resetn;
    wire unlocked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_lock dut (
        .clk(clk),
        .code(code),
        .resetn(resetn),
        .unlocked(unlocked)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            code = 4'b0000;
            @(negedge clk);
            resetn = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing correct code (4'b1101)", test_num);
            reset_dut();
            code = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing incorrect code (4'b0000)", test_num);
            reset_dut();
            code = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing incorrect code (4'b1111)", test_num);
            reset_dut();
            code = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing code off-by-one (4'b1100)", test_num);
            reset_dut();
            code = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing synchronous reset while correct code is applied", test_num);
            reset_dut();
            code = 4'b1101;
            @(negedge clk);
            resetn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing recovery from wrong code to right code", test_num);
            reset_dut();
            code = 4'b1010;
            @(posedge clk);
            #1;
            code = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing boundary code (4'b0101)", test_num);
            reset_dut();
            code = 4'b0101;
            @(posedge clk);
            #1;
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
        $display("digital_lock Testbench");
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
        input expected_unlocked;
        begin
            if (expected_unlocked === (expected_unlocked ^ unlocked ^ expected_unlocked)) begin
                $display("PASS");
                $display("  Outputs: unlocked=%b",
                         unlocked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: unlocked=%b",
                         expected_unlocked);
                $display("  Got:      unlocked=%b",
                         unlocked);
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
        $dumpvars(0,clk, code, resetn, unlocked);
    end

endmodule
