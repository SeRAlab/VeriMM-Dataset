`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [3:0] gray_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .gray_count(gray_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing once", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing 3 times", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing 8 times", test_num);
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rollover (16 steps)", test_num);
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Enable signal behavior", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1 en = 0;
            repeat(3) @(posedge clk);
            #1 en = 1;
            @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying index 15", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter Testbench");
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
        input [3:0] expected_gray_count;
        begin
            if (expected_gray_count === (expected_gray_count ^ gray_count ^ expected_gray_count)) begin
                $display("PASS");
                $display("  Outputs: gray_count=%h",
                         gray_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_count=%h",
                         expected_gray_count);
                $display("  Got:      gray_count=%h",
                         gray_count);
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
        $dumpvars(0,clk, en, rst, gray_count);
    end

endmodule
