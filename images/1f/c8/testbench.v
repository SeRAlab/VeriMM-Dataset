`timescale 1ns/1ps

module divide_by_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] data_in;
    wire divisible_by_8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_8 dut (
        .clk(clk),
        .data_in(data_in),
        .divisible_by_8(divisible_by_8)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking initial reset state", test_num);
            reset_dut();
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0", test_num);
            reset_dut();
            data_in = 3'd0; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 + 7 = 8 (Divisible)", test_num);
            reset_dut();
            data_in = 3'd1; @(posedge clk);
            data_in = 3'd7; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4 + 4 = 8 (Divisible)", test_num);
            reset_dut();
            data_in = 3'd4; @(posedge clk);
            data_in = 3'd4; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 + 1 = 2 (Not divisible)", test_num);
            reset_dut();
            data_in = 3'd1; @(posedge clk);
            data_in = 3'd1; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 + 3 + 2 = 8 (Divisible)", test_num);
            reset_dut();
            data_in = 3'd3; @(posedge clk);
            data_in = 3'd3; @(posedge clk);
            data_in = 3'd2; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 7+7+7+3 = 24 (Divisible)", test_num);
            reset_dut();
            data_in = 3'd7; @(posedge clk);
            data_in = 3'd7; @(posedge clk);
            data_in = 3'd7; @(posedge clk);
            data_in = 3'd3; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2 + 4 = 6 (Not divisible)", test_num);
            reset_dut();
            data_in = 3'd2; @(posedge clk);
            data_in = 3'd4; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence of zeros", test_num);
            reset_dut();
            data_in = 3'd0; @(posedge clk);
            data_in = 3'd0; @(posedge clk);
            data_in = 3'd0; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 7 + 2 = 9 (Remainder 1, Not divisible)", test_num);
            reset_dut();
            data_in = 3'd7; @(posedge clk);
            data_in = 3'd2; @(posedge clk);
            #1 #1;
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
        $display("divide_by_8 Testbench");
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
        input expected_divisible_by_8;
        begin
            if (expected_divisible_by_8 === (expected_divisible_by_8 ^ divisible_by_8 ^ expected_divisible_by_8)) begin
                $display("PASS");
                $display("  Outputs: divisible_by_8=%b",
                         divisible_by_8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divisible_by_8=%b",
                         expected_divisible_by_8);
                $display("  Got:      divisible_by_8=%b",
                         divisible_by_8);
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
        $dumpvars(0,clk, data_in, divisible_by_8);
    end

endmodule
