`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg branch_taken;
    reg clk;
    reg rst;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .address(address),
        .branch_taken(branch_taken),
        .clk(clk),
        .rst(rst),
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
            address = 0;
            branch_taken = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task train;

        input [1:0] addr;
        input taken;
        begin
            address = addr;
            branch_taken = taken;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state prediction", test_num);
            reset_dut();
            address = 2'b00;
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: SNT to WNT (00 -> 01)", test_num);
            reset_dut();
            train(2'b00, 1'b1);
            address = 2'b00;
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: WNT to WT (01 -> 10)", test_num);
            reset_dut();
            train(2'b01, 1'b1);
            train(2'b01, 1'b1);
            address = 2'b01;
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: WT to ST (10 -> 11)", test_num);
            reset_dut();
            train(2'b10, 1'b1);
            train(2'b10, 1'b1);
            train(2'b10, 1'b1);
            address = 2'b10;
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Saturation at ST (11 -> 11)", test_num);
            reset_dut();
            repeat(5) train(2'b00, 1'b1);
            address = 2'b00;
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ST down to WNT (11 -> 10 -> 01)", test_num);
            reset_dut();
            repeat(3) train(2'b11, 1'b1);
            train(2'b11, 1'b0);
            train(2'b11, 1'b0);
            address = 2'b11;
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Address Independence Check", test_num);
            reset_dut();

            repeat(3) train(2'b00, 1'b1);

            repeat(2) train(2'b11, 1'b0);

            address = 2'b00;
            #1 if (prediction !== 1'b1) $display("Addr 0 Failed");

            address = 2'b11;
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Saturation at SNT (00 -> 00)", test_num);
            reset_dut();
            repeat(3) train(2'b01, 1'b0);
            address = 2'b01;
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
        $dumpvars(0,address, branch_taken, clk, rst, prediction);
    end

endmodule
