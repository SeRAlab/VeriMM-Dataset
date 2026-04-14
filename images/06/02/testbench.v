`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Instruction Propagation", test_num);
            reset_dut();

            instruction_in = 32'hAAAA_BBBB;
            @(posedge clk);
            instruction_in = 32'h0;


            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction Sequence (No Hazard)", test_num);
            reset_dut();

            instruction_in = 32'h1111_1111; @(posedge clk);
            instruction_in = 32'h2222_2222; @(posedge clk);
            instruction_in = 32'h3333_3333; @(posedge clk);
            instruction_in = 32'h4444_4444; @(posedge clk);
            instruction_in = 32'h5555_5555; @(posedge clk);
            instruction_in = 32'h0;



            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Hazard/Stall Propagation", test_num);
            reset_dut();

            instruction_in = 32'hDEAD_BEEF; @(posedge clk);
            instruction_in = 32'hC0DE_C0DE; @(posedge clk);
            instruction_in = 32'h0;



            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hC0DE_C0DE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-Operation Reset", test_num);
            reset_dut();

            instruction_in = 32'hFFFF_FFFF; @(posedge clk);
            instruction_in = 32'hEEEE_EEEE; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            instruction_in = 32'h1234_5678; @(posedge clk);



            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
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
        input [31:0] expected_instruction_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h",
                         instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h",
                         expected_instruction_out);
                $display("  Got:      instruction_out=%h",
                         instruction_out);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out);
    end

endmodule
