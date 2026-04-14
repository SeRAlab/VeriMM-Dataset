`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg reset;
    wire [4:0] stage1;
    wire [4:0] stage2;
    wire [4:0] stage3;
    wire [4:0] stage4;
    wire [4:0] stage5;
    wire [4:0] stage6;
    wire [4:0] stage7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .stage1(stage1),
        .stage2(stage2),
        .stage3(stage3),
        .stage4(stage4),
        .stage5(stage5),
        .stage6(stage6),
        .stage7(stage7)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 5'b0;
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
            $display("\nTestcase %0d: Single Instruction Propagation (ADD)", test_num);
            reset_dut();


            instruction = 5'b00011;
            @(posedge clk); #1;


            instruction = 5'b00000;









            repeat(6) @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Pipeline Operation", test_num);
            reset_dut();


            instruction = 5'b00001; @(posedge clk); #1;
            instruction = 5'b00010; @(posedge clk); #1;
            instruction = 5'b00011; @(posedge clk); #1;
            instruction = 5'b00100; @(posedge clk); #1;
            instruction = 5'b00001; @(posedge clk); #1;
            instruction = 5'b00010; @(posedge clk); #1;
            instruction = 5'b00011; @(posedge clk); #1;



            #1;




            check_outputs(5'h03, 5'h02, 5'h01, 5'h04, 5'h03, 5'h02, 5'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Reset Mid-Operation", test_num);
            reset_dut();


            instruction = 5'b00100; @(posedge clk); #1;
            instruction = 5'b00100; @(posedge clk); #1;
            instruction = 5'b00100; @(posedge clk); #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Final Stage Check for SUB", test_num);
            reset_dut();

            instruction = 5'b00100;
            @(posedge clk); #1;
            instruction = 5'b00000;

            repeat(6) @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h00, 5'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [4:0] expected_stage1;
        input [4:0] expected_stage2;
        input [4:0] expected_stage3;
        input [4:0] expected_stage4;
        input [4:0] expected_stage5;
        input [4:0] expected_stage6;
        input [4:0] expected_stage7;
        begin
            if (expected_stage1 === (expected_stage1 ^ stage1 ^ expected_stage1) &&
                expected_stage2 === (expected_stage2 ^ stage2 ^ expected_stage2) &&
                expected_stage3 === (expected_stage3 ^ stage3 ^ expected_stage3) &&
                expected_stage4 === (expected_stage4 ^ stage4 ^ expected_stage4) &&
                expected_stage5 === (expected_stage5 ^ stage5 ^ expected_stage5) &&
                expected_stage6 === (expected_stage6 ^ stage6 ^ expected_stage6) &&
                expected_stage7 === (expected_stage7 ^ stage7 ^ expected_stage7)) begin
                $display("PASS");
                $display("  Outputs: stage1=%h, stage2=%h, stage3=%h, stage4=%h, stage5=%h, stage6=%h, stage7=%h",
                         stage1, stage2, stage3, stage4, stage5, stage6, stage7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage1=%h, stage2=%h, stage3=%h, stage4=%h, stage5=%h, stage6=%h, stage7=%h",
                         expected_stage1, expected_stage2, expected_stage3, expected_stage4, expected_stage5, expected_stage6, expected_stage7);
                $display("  Got:      stage1=%h, stage2=%h, stage3=%h, stage4=%h, stage5=%h, stage6=%h, stage7=%h",
                         stage1, stage2, stage3, stage4, stage5, stage6, stage7);
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
        $dumpvars(0,clk, instruction, reset, stage1, stage2, stage3, stage4, stage5, stage6, stage7);
    end

endmodule
