`timescale 1ns/1ps

module pipeline_processor_tb;

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
    pipeline_processor dut (
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
            instruction_in = 32'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Instruction Propagation", test_num);
            reset_dut();

            instruction_in = 32'hDEADBEEF;
            @(posedge clk); #1;
            instruction_in = 32'h0;



            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Pipeline Throughput", test_num);
            reset_dut();

            instruction_in = 32'h11111111; @(posedge clk); #1;
            instruction_in = 32'h22222222; @(posedge clk); #1;
            instruction_in = 32'h33333333; @(posedge clk); #1;
            instruction_in = 32'h44444444; @(posedge clk); #1;
            instruction_in = 32'h55555555; @(posedge clk); #1;



            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stall/Hazard Latency Check", test_num);
            reset_dut();

            instruction_in = 32'hABCDEF00; @(posedge clk); #1;
            instruction_in = 32'h0;



            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset Recovery", test_num);
            reset_dut();

            instruction_in = 32'hFFFFFFFF;
            repeat(2) @(posedge clk);

            reset_dut();

            instruction_in = 32'hCAFEFEED;
            repeat(5) @(posedge clk);
            #2;


            #1;



            check_outputs(32'hCAFEFEED);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Cycle-accurate Latency Check", test_num);
            reset_dut();

            instruction_in = 32'h12345678;
            @(posedge clk); #1;
            instruction_in = 32'h0;

            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;


            #1;



            check_outputs(32'h12345678);
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
