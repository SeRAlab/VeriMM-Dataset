`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] count_gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .reset(reset),
        .count_gray(count_gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            $display("\nTestcase %0d: Resetting counter...", test_num + 1);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(3'b101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(17) @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
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
        input [2:0] expected_count_gray;
        begin
            if (expected_count_gray === (expected_count_gray ^ count_gray ^ expected_count_gray)) begin
                $display("PASS");
                $display("  Outputs: count_gray=%h",
                         count_gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_gray=%h",
                         expected_count_gray);
                $display("  Got:      count_gray=%h",
                         count_gray);
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
        $dumpvars(0,clk, reset, count_gray);
    end

endmodule
