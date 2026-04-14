`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    reg valid;
    wire [31:0] execution_out;
    wire [31:0] instruction_out;
    wire [7:0] opcode_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .valid(valid),
        .execution_out(execution_out),
        .instruction_out(instruction_out),
        .opcode_out(opcode_out)
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
            valid = 0;
            instruction_in = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single instruction propagation", test_num);
            reset_dut();


            instruction_in = 32'hAA001122;
            valid = 1;
            @(posedge clk);


            valid = 0;
            instruction_in = 0;
            @(posedge clk);


            @(posedge clk);




            #1;





            check_outputs(32'hAA001122, 32'hAA001122, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-pipeline", test_num);
            reset_dut();


            instruction_in = 32'hBB445566;
            valid = 1;
            @(posedge clk);


            valid = 0;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            @(posedge clk);


            #1;



            check_outputs(32'h0, 32'h0, 8'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back instructions", test_num);
            reset_dut();


            instruction_in = 32'h01000001;
            valid = 1;
            @(posedge clk);


            instruction_in = 32'h02000002;
            valid = 1;
            @(posedge clk);


            instruction_in = 32'h03000003;
            valid = 1;
            @(posedge clk);


            valid = 0;
            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(32'h03000003, 32'h03000003, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid signal gating test", test_num);
            reset_dut();


            instruction_in = 32'hFF998877;
            valid = 0;
            repeat (4) @(posedge clk);


            #1;



            check_outputs(32'h0, 32'h0, 8'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode extraction (55h)", test_num);
            reset_dut();

            instruction_in = 32'h55123456;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat (3) @(posedge clk);

            #1;


            check_outputs(32'h55123456, 32'h55123456, 8'h55);
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
        input [31:0] expected_execution_out;
        input [31:0] expected_instruction_out;
        input [7:0] expected_opcode_out;
        begin
            if (expected_execution_out === (expected_execution_out ^ execution_out ^ expected_execution_out) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_opcode_out === (expected_opcode_out ^ opcode_out ^ expected_opcode_out)) begin
                $display("PASS");
                $display("  Outputs: execution_out=%h, instruction_out=%h, opcode_out=%h",
                         execution_out, instruction_out, opcode_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: execution_out=%h, instruction_out=%h, opcode_out=%h",
                         expected_execution_out, expected_instruction_out, expected_opcode_out);
                $display("  Got:      execution_out=%h, instruction_out=%h, opcode_out=%h",
                         execution_out, instruction_out, opcode_out);
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
        $dumpvars(0,clk, instruction_in, reset, valid, execution_out, instruction_out, opcode_out);
    end

endmodule
