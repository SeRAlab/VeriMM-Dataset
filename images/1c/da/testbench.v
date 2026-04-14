`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] actual;
    reg clk;
    reg [1:0] predicted;
    reg reset;
    wire [1:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual(actual),
        .clk(clk),
        .predicted(predicted),
        .reset(reset),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            actual = 2'b00;
            predicted = 2'b00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset State (Strongly Not Taken)", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 00 -> 01 (One Taken Branch)", test_num);
            reset_dut();
            actual = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 00 -> 10 (Two Taken Branches)", test_num);
            reset_dut();
            actual = 2'b11;
            @(posedge clk);
            #2;
            actual = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 00 -> 11 (Three Taken Branches)", test_num);
            reset_dut();
            actual = 2'b11;
            @(posedge clk); #2;
            actual = 2'b11;
            @(posedge clk); #2;
            actual = 2'b11;
            @(posedge clk); #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Saturate at 11 (Four Taken Branches)", test_num);
            reset_dut();
            repeat(4) begin
                actual = 2'b11;
                @(posedge clk); #2;
            end
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 00 -> 01 -> 00 (Taken then Not Taken)", test_num);
            reset_dut();
            actual = 2'b11;
            @(posedge clk); #2;
            actual = 2'b00;
            @(posedge clk); #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 11 -> 10 (Saturate then Not Taken)", test_num);
            reset_dut();
            repeat(3) begin
                actual = 2'b11; @(posedge clk); #2;
            end
            actual = 2'b00;
            @(posedge clk); #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 11 -> 01 (Three Takens, Two Not Takens)", test_num);
            reset_dut();
            repeat(3) begin
                actual = 2'b11; @(posedge clk); #2;
            end
            repeat(2) begin
                actual = 2'b00; @(posedge clk); #2;
            end
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Cycle (00 to 11 to 00)", test_num);
            reset_dut();
            repeat(3) begin
                actual = 2'b11; @(posedge clk); #2;
            end
            repeat(3) begin
                actual = 2'b00; @(posedge clk); #2;
            end
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Saturate at 00 (Not Taken on reset state)", test_num);
            reset_dut();
            actual = 2'b00;
            @(posedge clk); #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed T/NT behavior", test_num);
            reset_dut();
            actual = 2'b11; @(posedge clk); #2;
            actual = 2'b11; @(posedge clk); #2;
            actual = 2'b00; @(posedge clk); #2;
            actual = 2'b11; @(posedge clk); #2;
            actual = 2'b11; @(posedge clk); #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("branch_predictor Testbench");
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
        testcase011();
        
        
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
        input [1:0] expected_counter;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
        $dumpvars(0,actual, clk, predicted, reset, counter);
    end

endmodule
