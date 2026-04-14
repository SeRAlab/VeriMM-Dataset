`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] return1;
    reg [15:0] return2;
    reg [15:0] return3;
    reg [15:0] risk1;
    reg [15:0] risk2;
    reg [15:0] risk3;
    wire [15:0] weight1;
    wire [15:0] weight2;
    wire [15:0] weight3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .clk(clk),
        .reset(reset),
        .return1(return1),
        .return2(return2),
        .return3(return3),
        .risk1(risk1),
        .risk2(risk2),
        .risk3(risk3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            return1 = 0; return2 = 0; return3 = 0;
            risk1 = 0;   risk2 = 0;   risk3 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equal Assets", test_num);
            reset_dut();

            return1 = 16'd1000; risk1 = 16'd100;
            return2 = 16'd1000; risk2 = 16'd100;
            return3 = 16'd1000; risk3 = 16'd100;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h5555, 16'h5555, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asset 1 Dominant", test_num);
            reset_dut();

            return1 = 16'd200; risk1 = 16'd10;
            return2 = 16'd100; risk2 = 16'd10;
            return3 = 16'd100; risk3 = 16'd10;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h8000, 16'h4000, 16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Risk Penalty", test_num);
            reset_dut();

            return1 = 16'd100; risk1 = 16'd10;
            return2 = 16'd400; risk2 = 16'd80;
            return3 = 16'd100; risk3 = 16'd20;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h8000, 16'h4000, 16'h4000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Return Asset", test_num);
            reset_dut();

            return1 = 16'd100; risk1 = 16'd10;
            return2 = 16'd100; risk2 = 16'd10;
            return3 = 16'd0;   risk3 = 16'd10;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h8000, 16'h8000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Asset Dominance", test_num);
            reset_dut();

            return1 = 16'd1000; risk1 = 16'd1;
            return2 = 16'd1;    risk2 = 16'd1000;
            return3 = 16'd1;    risk3 = 16'd1000;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(16'hFFFD, 16'h0001, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_weight1;
        input [15:0] expected_weight2;
        input [15:0] expected_weight3;
        begin
            if (expected_weight1 === (expected_weight1 ^ weight1 ^ expected_weight1) &&
                expected_weight2 === (expected_weight2 ^ weight2 ^ expected_weight2) &&
                expected_weight3 === (expected_weight3 ^ weight3 ^ expected_weight3)) begin
                $display("PASS");
                $display("  Outputs: weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight1=%h, weight2=%h, weight3=%h",
                         expected_weight1, expected_weight2, expected_weight3);
                $display("  Got:      weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
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
        $dumpvars(0,clk, reset, return1, return2, return3, risk1, risk2, risk3, weight1, weight2, weight3);
    end

endmodule
