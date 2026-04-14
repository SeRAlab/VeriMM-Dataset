`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg rst;
    wire [4:0] ex_stage;
    wire [4:0] id_stage;
    wire [4:0] if_stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .ex_stage(ex_stage),
        .id_stage(id_stage),
        .if_stage(if_stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 5'b0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Filling the pipeline with instructions 0x01, 0x02, 0x03", test_num);
            reset_dut();


            instruction_in = 5'h01;
            @(posedge clk);


            #1 instruction_in = 5'h02;
            @(posedge clk);


            #1 instruction_in = 5'h03;
            @(posedge clk);


            #1 #1;
 check_outputs(5'h01, 5'h02, 5'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying pipeline reset clears all stages", test_num);
            reset_dut();


            instruction_in = 5'h0A;
            @(posedge clk);
            #1 instruction_in = 5'h0B;
            @(posedge clk);


            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;


            #1 #1;
 check_outputs(5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Passing instruction 0x1F through all stages", test_num);
            reset_dut();


            instruction_in = 5'h1F;
            @(posedge clk);


            #1 instruction_in = 5'h00;
            @(posedge clk);


            #1 instruction_in = 5'h00;
            @(posedge clk);


            #1 #1;
 check_outputs(5'h1F, 5'h00, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum instruction value (0x1F) sequence", test_num);
            reset_dut();

            #1 instruction_in = 5'h1F;
            @(posedge clk);
            #1 instruction_in = 5'h1E;
            @(posedge clk);
            #1 instruction_in = 5'h1D;
            @(posedge clk);


            #1 #1;
 check_outputs(5'h1F, 5'h1E, 5'h1D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline flow with NOPs (zeros)", test_num);
            reset_dut();

            #1 instruction_in = 5'h05;
            @(posedge clk);
            #1 instruction_in = 5'h00;
            @(posedge clk);
            #1 instruction_in = 5'h07;
            @(posedge clk);


            #1 #1;
 check_outputs(5'h05, 5'h00, 5'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [4:0] expected_ex_stage;
        input [4:0] expected_id_stage;
        input [4:0] expected_if_stage;
        begin
            if (expected_ex_stage === (expected_ex_stage ^ ex_stage ^ expected_ex_stage) &&
                expected_id_stage === (expected_id_stage ^ id_stage ^ expected_id_stage) &&
                expected_if_stage === (expected_if_stage ^ if_stage ^ expected_if_stage)) begin
                $display("PASS");
                $display("  Outputs: ex_stage=%h, id_stage=%h, if_stage=%h",
                         ex_stage, id_stage, if_stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_stage=%h, id_stage=%h, if_stage=%h",
                         expected_ex_stage, expected_id_stage, expected_if_stage);
                $display("  Got:      ex_stage=%h, id_stage=%h, if_stage=%h",
                         ex_stage, id_stage, if_stage);
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
        $dumpvars(0,clk, instruction_in, rst, ex_stage, id_stage, if_stage);
    end

endmodule
