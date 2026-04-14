`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg rst;
    wire [4:0] out_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .out_instruction(out_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single instruction (5'h0A) through pipeline", test_num);
            reset_dut();


            instruction = 5'h0A;
            @(posedge clk);


            instruction = 5'h00;
            repeat(4) @(posedge clk);


            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max instruction value (5'h1F) through pipeline", test_num);
            reset_dut();

            instruction = 5'h1F;
            @(posedge clk);

            instruction = 5'h00;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Back-to-back instructions, checking final instruction (5'h05)", test_num);
            reset_dut();


            instruction = 5'h01; @(posedge clk);
            instruction = 5'h02; @(posedge clk);
            instruction = 5'h03; @(posedge clk);
            instruction = 5'h04; @(posedge clk);
            instruction = 5'h05; @(posedge clk);



            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify pipeline state after reset", test_num);
            reset_dut();



            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit pattern (5'h15)", test_num);
            reset_dut();

            instruction = 5'b10101;
            @(posedge clk);

            instruction = 5'h00;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(5'h15);
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
        input [4:0] expected_out_instruction;
        begin
            if (expected_out_instruction === (expected_out_instruction ^ out_instruction ^ expected_out_instruction)) begin
                $display("PASS");
                $display("  Outputs: out_instruction=%h",
                         out_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_instruction=%h",
                         expected_out_instruction);
                $display("  Got:      out_instruction=%h",
                         out_instruction);
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
        $dumpvars(0,clk, instruction, rst, out_instruction);
    end

endmodule
