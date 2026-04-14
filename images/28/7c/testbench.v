`timescale 1ns/1ps

module pipeline_cpu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
    wire [31:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_cpu dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 32'h00230820;
            @(posedge clk);
            #1;






            instruction_in = 32'h0;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00230820);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline Full Stream", test_num);
            reset_dut();


            instruction_in = 32'hAAAA_AAAA; @(posedge clk); #1;
            instruction_in = 32'hBBBB_BBBB; @(posedge clk); #1;
            instruction_in = 32'hCCCC_CCCC; @(posedge clk); #1;
            instruction_in = 32'hDDDD_DDDD; @(posedge clk); #1;
            instruction_in = 32'hEEEE_EEEE; @(posedge clk); #1;



            instruction_in = 32'h0;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hEEEE_EEEE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hazard Sequence", test_num);
            reset_dut();




            instruction_in = 32'h00230820; @(posedge clk); #1;
            instruction_in = 32'h00252022; @(posedge clk); #1;

            instruction_in = 32'h0;
            repeat (4) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00252022);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            instruction_in = 32'h1111_1111; @(posedge clk); #1;
            instruction_in = 32'h2222_2222; @(posedge clk); #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent Instructions", test_num);
            reset_dut();

            instruction_in = 32'hF0F0_F0F0; @(posedge clk); #1;
            instruction_in = 32'h0000_0000; @(posedge clk); #1;
            instruction_in = 32'h0000_0000; @(posedge clk); #1;
            instruction_in = 32'h0F0F_0F0F; @(posedge clk); #1;


            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0F0F_0F0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_cpu Testbench");
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out);
    end

endmodule
