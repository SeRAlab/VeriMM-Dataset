`timescale 1ns/1ps

module pipeline_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction;
    wire [7:0] ex_stage;
    wire [7:0] id_stage;
    wire [7:0] if_stage;
    wire [7:0] mem_stage;
    wire [7:0] wb_stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_register dut (
        .clk(clk),
        .instruction(instruction),
        .ex_stage(ex_stage),
        .id_stage(id_stage),
        .if_stage(if_stage),
        .mem_stage(mem_stage),
        .wb_stage(wb_stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Resetting pipeline...");
        instruction = 8'h00;
        repeat (6) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single instruction propagation (0xA5)", test_num);
        reset_dut();


        instruction = 8'hA5;
        @(posedge clk);
        #1;


        instruction = 8'h00;
        repeat (4) @(posedge clk);
        #1;



        #1;




        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Continuous instruction stream", test_num);
        reset_dut();


        instruction = 8'h11; @(posedge clk); #1;
        instruction = 8'h22; @(posedge clk); #1;
        instruction = 8'h33; @(posedge clk); #1;
        instruction = 8'h44; @(posedge clk); #1;
        instruction = 8'h55; @(posedge clk); #1;



        #1;




        check_outputs(8'h33, 8'h44, 8'h55, 8'h22, 8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Pipeline saturation with 0xFF", test_num);
        reset_dut();

        instruction = 8'hFF;
        repeat (5) @(posedge clk);
        #1;


        #1;



        check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Partial pipeline flush", test_num);
        reset_dut();


        instruction = 8'hD1; @(posedge clk);
        instruction = 8'hD2; @(posedge clk);
        instruction = 8'hD3; @(posedge clk);
        instruction = 8'hD4; @(posedge clk);
        instruction = 8'hD5; @(posedge clk);
        #1;


        instruction = 8'h00;
        repeat (2) @(posedge clk);
        #1;






        #1;







        check_outputs(8'hD5, 8'h00, 8'h00, 8'hD4, 8'hD3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating patterns", test_num);
        reset_dut();

        instruction = 8'hAA; @(posedge clk);
        instruction = 8'h55; @(posedge clk);
        instruction = 8'hAA; @(posedge clk);
        instruction = 8'h55; @(posedge clk);
        instruction = 8'hAA; @(posedge clk);
        #1;


        #1;



        check_outputs(8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_register Testbench");
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
        input [7:0] expected_ex_stage;
        input [7:0] expected_id_stage;
        input [7:0] expected_if_stage;
        input [7:0] expected_mem_stage;
        input [7:0] expected_wb_stage;
        begin
            if (expected_ex_stage === (expected_ex_stage ^ ex_stage ^ expected_ex_stage) &&
                expected_id_stage === (expected_id_stage ^ id_stage ^ expected_id_stage) &&
                expected_if_stage === (expected_if_stage ^ if_stage ^ expected_if_stage) &&
                expected_mem_stage === (expected_mem_stage ^ mem_stage ^ expected_mem_stage) &&
                expected_wb_stage === (expected_wb_stage ^ wb_stage ^ expected_wb_stage)) begin
                $display("PASS");
                $display("  Outputs: ex_stage=%h, id_stage=%h, if_stage=%h, mem_stage=%h, wb_stage=%h",
                         ex_stage, id_stage, if_stage, mem_stage, wb_stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_stage=%h, id_stage=%h, if_stage=%h, mem_stage=%h, wb_stage=%h",
                         expected_ex_stage, expected_id_stage, expected_if_stage, expected_mem_stage, expected_wb_stage);
                $display("  Got:      ex_stage=%h, id_stage=%h, if_stage=%h, mem_stage=%h, wb_stage=%h",
                         ex_stage, id_stage, if_stage, mem_stage, wb_stage);
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
        $dumpvars(0,clk, instruction, ex_stage, id_stage, if_stage, mem_stage, wb_stage);
    end

endmodule
