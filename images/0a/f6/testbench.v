`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_hazard;
    reg data_hazard;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] instruction_out;
    wire [15:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .control_hazard(control_hazard),
        .data_hazard(data_hazard),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_hazard = 0;
            data_hazard = 0;
            instruction_in = 16'h0000;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic functional flow (No hazards)", test_num);
            reset_dut();


            instruction_in = 16'hA001;
            @(posedge clk);


            instruction_in = 16'h0000;


            repeat (4) @(posedge clk);


            #1;
            #1;

            check_outputs(16'hA001, 16'hA001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hazard (1-cycle Stall)", test_num);
            reset_dut();


            instruction_in = 16'hB002;
            @(posedge clk);


            instruction_in = 16'h0000;
            data_hazard = 1;
            @(posedge clk);


            data_hazard = 0;
            @(posedge clk);


            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hB002, 16'hB002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Control Hazard", test_num);
            reset_dut();


            instruction_in = 16'hC003;
            @(posedge clk);


            control_hazard = 1;
            @(posedge clk);

            control_hazard = 0;




            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hC003, 16'hC003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Instruction Stream", test_num);
            reset_dut();


            instruction_in = 16'h1001; @(posedge clk);
            instruction_in = 16'h2002; @(posedge clk);
            instruction_in = 16'h3003; @(posedge clk);
            instruction_in = 16'h4004; @(posedge clk);
            instruction_in = 16'h5005; @(posedge clk);


            #1;
            #1;

            check_outputs(16'h1001, 16'h1001);


            @(posedge clk); #1;
            #1;

            check_outputs(16'h2002, 16'h2002);

            @(posedge clk); #1;
            #1;

            check_outputs(16'h3003, 16'h3003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Hazards", test_num);
            reset_dut();

            instruction_in = 16'hDEAD;
            @(posedge clk);


            data_hazard = 1;
            control_hazard = 1;
            @(posedge clk);

            data_hazard = 0;
            control_hazard = 0;


            repeat (5) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hDEAD, 16'hDEAD);
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
        input [15:0] expected_instruction_out;
        input [15:0] expected_result_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, result_out=%h",
                         instruction_out, result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, result_out=%h",
                         expected_instruction_out, expected_result_out);
                $display("  Got:      instruction_out=%h, result_out=%h",
                         instruction_out, result_out);
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
        $dumpvars(0,clk, control_hazard, data_hazard, instruction_in, reset, instruction_out, result_out);
    end

endmodule
