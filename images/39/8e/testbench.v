`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
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
        instruction_in = 32'h0;
        @(posedge clk);
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task nop_cycles;

        input integer n;
        begin
            repeat(n) begin
                instruction_in = 32'h0;
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %03d: Basic ADDI", test_num);
        reset_dut();


        instruction_in = {OP_ADDI, 5'd0, 5'd1, 16'd15};
        @(posedge clk);


        nop_cycles(5);

        #1;


        check_outputs(32'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %03d: EX-to-EX Forwarding", test_num);
        reset_dut();


        instruction_in = {OP_ADDI, 5'd0, 5'd1, 16'd10};
        @(posedge clk);


        instruction_in = {OP_RTYPE, 5'd1, 5'd1, 5'd2, 5'd0, FUNCT_ADD};
        @(posedge clk);

        nop_cycles(5);

        #1;


        check_outputs(32'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase %03d: MEM-to-EX Forwarding", test_num);
        reset_dut();


        instruction_in = {OP_ADDI, 5'd0, 5'd1, 16'd20}; @(posedge clk);


        instruction_in = 32'h0; @(posedge clk);


        instruction_in = {OP_RTYPE, 5'd1, 5'd1, 5'd2, 5'd0, FUNCT_ADD}; @(posedge clk);

        nop_cycles(5);

        #1;


        check_outputs(32'd40);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase %03d: Control Hazard (Branch Taken)", test_num);
        reset_dut();


        instruction_in = {OP_ADDI, 5'd0, 5'd1, 16'd5}; @(posedge clk);


        instruction_in = {OP_BEQ, 5'd1, 5'd1, 16'd2}; @(posedge clk);


        instruction_in = {OP_ADDI, 5'd0, 5'd2, 16'd100}; @(posedge clk);


        instruction_in = {OP_ADDI, 5'd0, 5'd3, 16'd50}; @(posedge clk);

        nop_cycles(6);



        #1;




        check_outputs(32'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase %03d: Complex Sequence", test_num);
        reset_dut();

        instruction_in = {OP_ADDI, 5'd0, 5'd1, 16'd10}; @(posedge clk);
        instruction_in = {OP_RTYPE, 5'd1, 5'd1, 5'd2, 5'd0, FUNCT_SUB}; @(posedge clk);
        instruction_in = {OP_ADDI, 5'd2, 5'd3, 16'd5}; @(posedge clk);

        nop_cycles(6);
        #1;

        check_outputs(32'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [31:0] expected_result_out;
        begin
            if (expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: result_out=%h",
                         result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_out=%h",
                         expected_result_out);
                $display("  Got:      result_out=%h",
                         result_out);
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
        $dumpvars(0,clk, instruction_in, reset, result_out);
    end

endmodule
