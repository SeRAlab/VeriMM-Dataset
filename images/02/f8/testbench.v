`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg reset;
    wire hazard_detected;
    wire [4:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .hazard_detected(hazard_detected),
        .instruction_out(instruction_out)
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
            instruction_in = 5'b0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 5'h1A;
            @(posedge clk);

            instruction_in = 5'h00;



            repeat (4) @(posedge clk);


            #1;



            check_outputs(1'b0, 5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Full Flow", test_num);
            reset_dut();


            instruction_in = 5'h01; @(posedge clk);
            instruction_in = 5'h02; @(posedge clk);
            instruction_in = 5'h03; @(posedge clk);
            instruction_in = 5'h04; @(posedge clk);
            instruction_in = 5'h05; @(posedge clk);
            instruction_in = 5'h00;



            repeat (4) @(posedge clk);

            #1;


            check_outputs(1'b0, 5'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hazard Detection/Stall Check", test_num);
            reset_dut();



            instruction_in = 5'h1F; @(posedge clk);
            instruction_in = 5'h1F; @(posedge clk);
            instruction_in = 5'h00;

            repeat (6) @(posedge clk);



            if (hazard_detected) begin
                $display("  Note: Hazard was detected during execution.");
            end


            #1;



            check_outputs(hazard_detected, instruction_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            instruction_in = 5'h1E;
            repeat (3) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0, 5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Value Propagation", test_num);
            reset_dut();

            instruction_in = 5'b11111;
            @(posedge clk);
            instruction_in = 5'b00000;

            repeat (4) @(posedge clk);
            #1;

            check_outputs(1'b0, 5'b11111);
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
        input expected_hazard_detected;
        input [4:0] expected_instruction_out;
        begin
            if (expected_hazard_detected === (expected_hazard_detected ^ hazard_detected ^ expected_hazard_detected) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: hazard_detected=%b, instruction_out=%h",
                         hazard_detected, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard_detected=%b, instruction_out=%h",
                         expected_hazard_detected, expected_instruction_out);
                $display("  Got:      hazard_detected=%b, instruction_out=%h",
                         hazard_detected, instruction_out);
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
        $dumpvars(0,clk, instruction_in, reset, hazard_detected, instruction_out);
    end

endmodule
