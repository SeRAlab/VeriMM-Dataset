`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
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
        .reset(reset),
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
            @(posedge clk);
            reset = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Latency Check...");
            reset_dut();
            test_num = 1;


            instruction_in = 32'hAAAA_AAAA;
            @(posedge clk);


            instruction_in = 32'h0;
            repeat(3) @(posedge clk);



            #1;




            check_outputs(32'hAAAA_AAAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Pipeline Throughput...");
            reset_dut();
            test_num = 2;


            instruction_in = 32'h1111_1111; @(posedge clk);
            instruction_in = 32'h2222_2222; @(posedge clk);
            instruction_in = 32'h3333_3333; @(posedge clk);
            instruction_in = 32'h4444_4444; @(posedge clk);
            instruction_in = 32'h5555_5555; @(posedge clk);


            #1;



            check_outputs(32'h1111_1111, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Hazard Stall...");
            reset_dut();
            test_num = 3;



            instruction_in = 32'h0001_1020;
            @(posedge clk);
            instruction_in = 32'h0021_2020;
            @(posedge clk);




            #1;





            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Reset during operation...");
            reset_dut();
            test_num = 4;


            instruction_in = 32'hBCBC_BCBC; @(posedge clk);
            instruction_in = 32'hDADA_DADA; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Stall Resolution...");
            reset_dut();
            test_num = 5;


            instruction_in = 32'h0001_1020; @(posedge clk);
            instruction_in = 32'h0021_2020; @(posedge clk);



            repeat(6) @(posedge clk);


            #1;



            check_outputs(32'h0021_2020, 1'b0);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out, stall);
    end

endmodule
