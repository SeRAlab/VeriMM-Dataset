`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] instruction_ex;
    wire [15:0] instruction_id;
    wire [15:0] instruction_if;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_ex(instruction_ex),
        .instruction_id(instruction_id),
        .instruction_if(instruction_if)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 16'h0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Pipeline Fill", test_num);
            reset_dut();


            instruction_in = 16'hAAAA;
            @(posedge clk); #2;


            instruction_in = 16'hBBBB;
            @(posedge clk); #2;


            instruction_in = 16'hCCCC;
            @(posedge clk); #2;



            #1;




            check_outputs(16'hAAAA, 16'hBBBB, 16'hCCCC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 16'h1234;
            @(posedge clk); #2;


            instruction_in = 16'h0000;
            @(posedge clk); #2;


            instruction_in = 16'h0000;
            @(posedge clk); #2;


            #1;



            check_outputs(16'h1234, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Shifting", test_num);
            reset_dut();

            instruction_in = 16'h1111; @(posedge clk); #2;
            instruction_in = 16'h2222; @(posedge clk); #2;
            instruction_in = 16'h3333; @(posedge clk); #2;
            instruction_in = 16'h4444; @(posedge clk); #2;






            #1;







            check_outputs(16'h2222, 16'h3333, 16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-operation Reset", test_num);
            reset_dut();

            instruction_in = 16'hF0F0; @(posedge clk); #2;
            instruction_in = 16'h0F0F; @(posedge clk); #2;


            reset = 1;
            @(posedge clk); #2;
            reset = 0;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
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
        input [15:0] expected_instruction_ex;
        input [15:0] expected_instruction_id;
        input [15:0] expected_instruction_if;
        begin
            if (expected_instruction_ex === (expected_instruction_ex ^ instruction_ex ^ expected_instruction_ex) &&
                expected_instruction_id === (expected_instruction_id ^ instruction_id ^ expected_instruction_id) &&
                expected_instruction_if === (expected_instruction_if ^ instruction_if ^ expected_instruction_if)) begin
                $display("PASS");
                $display("  Outputs: instruction_ex=%h, instruction_id=%h, instruction_if=%h",
                         instruction_ex, instruction_id, instruction_if);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_ex=%h, instruction_id=%h, instruction_if=%h",
                         expected_instruction_ex, expected_instruction_id, expected_instruction_if);
                $display("  Got:      instruction_ex=%h, instruction_id=%h, instruction_if=%h",
                         instruction_ex, instruction_id, instruction_if);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_ex, instruction_id, instruction_if);
    end

endmodule
