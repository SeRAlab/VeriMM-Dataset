`timescale 1ns/1ps

module gray_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [5:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_counter dut (
        .clk(clk),
        .rst(rst),
        .gray_out(gray_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Step Check", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Two Step Check", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mid-point check (31 steps)", test_num);
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(6'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MSB transition (32 steps)", test_num);
            reset_dut();
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(6'h30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Max value check (63 steps)", test_num);
            reset_dut();
            repeat(63) @(posedge clk);
            #1;
            #1;

            check_outputs(6'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Wrap-around check (64 steps)", test_num);
            reset_dut();
            repeat(64) @(posedge clk);
            #1;
            #1;

            check_outputs(6'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_counter Testbench");
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
        input [5:0] expected_gray_out;
        begin
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
        $dumpvars(0,clk, rst, gray_out);
    end

endmodule
