`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
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
            enable = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Asynchronous Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Enable Disabled Check (Should stay at 0)", test_num);
            reset_dut();
            enable = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: First transition (00000 -> 10000)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 5 transitions (00000 -> 11111)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: 6 transitions (11111 -> 01111)", test_num);
            reset_dut();
            enable = 1;
            repeat(6) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: 9 transitions (00001)", test_num);
            reset_dut();
            enable = 1;
            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: 10 transitions (Cycle loop back to 00000)", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: 12 transitions (Wrap around to 11000)", test_num);
            reset_dut();
            enable = 1;
            repeat(12) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Enable Toggle Check", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Asynchronous Reset During Operation", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            #3 reset = 1;
            #2;
            #1;

            check_outputs(5'b00000);
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
        testcase010();
        
        
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, enable, reset, q);
    end

endmodule
