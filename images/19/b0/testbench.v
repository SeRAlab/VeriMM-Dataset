`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] branch_addr;
    reg clk;
    reg rst;
    reg taken;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .branch_addr(branch_addr),
        .clk(clk),
        .rst(rst),
        .taken(taken),
        .prediction(prediction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            branch_addr = 0;
            taken = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task train_predictor;

        input [3:0] addr;
        input is_taken;
        begin
            branch_addr = addr;
            taken = is_taken;
            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial prediction check (Expected: 1)", test_num);
            reset_dut();
            branch_addr = 4'hA;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition to Strongly Taken (Expected: 1)", test_num);
            reset_dut();
            train_predictor(4'h1, 1);
            branch_addr = 4'h1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition to Weakly Not Taken (Expected: 0)", test_num);
            reset_dut();
            train_predictor(4'h2, 0);
            branch_addr = 4'h2;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition to Strongly Not Taken (Expected: 0)", test_num);
            reset_dut();
            train_predictor(4'h3, 0);
            train_predictor(4'h3, 0);
            branch_addr = 4'h3;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate High check (Expected: 1)", test_num);
            reset_dut();
            train_predictor(4'h5, 1);
            train_predictor(4'h5, 1);
            train_predictor(4'h5, 1);
            branch_addr = 4'h5;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Saturate Low check (Expected: 0)", test_num);
            reset_dut();
            train_predictor(4'h6, 0);
            train_predictor(4'h6, 0);
            train_predictor(4'h6, 0);
            branch_addr = 4'h6;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address independence check (Expected: 1)", test_num);
            reset_dut();

            train_predictor(4'h4, 0);
            train_predictor(4'h4, 0);

            branch_addr = 4'h8;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Recovery to Taken check (Expected: 1)", test_num);
            reset_dut();
            train_predictor(4'hF, 0);
            train_predictor(4'hF, 0);
            train_predictor(4'hF, 1);
            train_predictor(4'hF, 1);
            branch_addr = 4'hF;
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
        $dumpvars(0,branch_addr, clk, rst, taken, prediction);
    end

endmodule
