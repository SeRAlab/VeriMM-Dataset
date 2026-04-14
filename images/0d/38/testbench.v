`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg rst;
    wire [31:0] instruction_out;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .instruction_out(instruction_out),
        .stall(stall)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Instruction Propagation", test_num);
            reset_dut();

            instruction_in = 32'hAABBCCDD;
            @(posedge clk);
            #1 instruction_in = 32'h0;


            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(32'hAABBCCDD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Load-Use Hazard Detection (Stall)", test_num);
            reset_dut();


            instruction_in = 32'h8C210000;
            @(posedge clk);


            #1 instruction_in = 32'h00221820;
            @(posedge clk);



            #1 if (stall !== 1'b1) begin
                $display("Error: Stall not asserted during load-use hazard at time %0t", $time);
            end

            #1 instruction_in = 32'h0;



            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(32'h00221820, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Continuous Pipeline Stream", test_num);
            reset_dut();

            instruction_in = 32'h11111111; @(posedge clk);
            #1 instruction_in = 32'h22222222; @(posedge clk);
            #1 instruction_in = 32'h33333333; @(posedge clk);
            #1 instruction_in = 32'h44444444; @(posedge clk);
            #1 instruction_in = 32'h55555555; @(posedge clk);
            #1 instruction_in = 32'h0;




            repeat(6) @(posedge clk);

            #1 #1;
 check_outputs(32'h55555555, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset Mid-Execution", test_num);
            reset_dut();

            instruction_in = 32'hFFFFFFFF;
            repeat(3) @(posedge clk);

            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;

            #1 #1;
 check_outputs(32'h0, 1'b0);
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
        input expected_stall;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, stall=%b",
                         instruction_out, stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, stall=%b",
                         expected_instruction_out, expected_stall);
                $display("  Got:      instruction_out=%h, stall=%b",
                         instruction_out, stall);
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out, stall);
    end

endmodule
