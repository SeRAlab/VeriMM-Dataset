`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] branch_addr;
    reg branch_outcome;
    reg clk;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .branch_addr(branch_addr),
        .branch_outcome(branch_outcome),
        .clk(clk),
        .prediction(prediction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        branch_outcome = 0;
        repeat(4) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 00 (Strongly Not Taken)", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 01 (Weakly Not Taken)", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        branch_outcome = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 10 (Weakly Taken)", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        branch_outcome = 1; @(posedge clk);
        branch_outcome = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 11 (Strongly Taken)", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(3) begin
            branch_outcome = 1; @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 11 Saturation", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(5) begin
            branch_outcome = 1; @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition 11 to 10", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(3) begin branch_outcome = 1; @(posedge clk); end
        branch_outcome = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition 10 to 01", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(3) begin branch_outcome = 1; @(posedge clk); end
        repeat(2) begin branch_outcome = 0; @(posedge clk); end
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition 01 to 00", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(3) begin branch_outcome = 1; @(posedge clk); end
        repeat(3) begin branch_outcome = 0; @(posedge clk); end
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State 00 Saturation", test_num);
        branch_addr = 4'b0000;
        reset_dut();
        repeat(2) begin
            branch_outcome = 0; @(posedge clk);
        end
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Different branch address 4'b1100", test_num);
        branch_addr = 4'b1100;
        reset_dut();
        branch_outcome = 1; @(posedge clk);
        branch_outcome = 1; @(posedge clk);
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
        input expected_prediction;
        begin
            if (expected_prediction === (expected_prediction ^ prediction ^ expected_prediction)) begin
                $display("PASS");
                $display("  Outputs: prediction=%b",
                         prediction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction=%b",
                         expected_prediction);
                $display("  Got:      prediction=%b",
                         prediction);
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
        $dumpvars(0,branch_addr, branch_outcome, clk, prediction);
    end

endmodule
