`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg reset;
    wire [15:0] data_out;
    wire [15:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .data_out(data_out),
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
            instruction_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 16'hA001;
            @(posedge clk);


            instruction_in = 16'h0000;
            repeat (4) @(posedge clk);



            #1;




            check_outputs(16'hA001, 16'hA001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Continuous Pipeline Flow", test_num);
            reset_dut();

            instruction_in = 16'h1111; @(posedge clk);
            instruction_in = 16'h2222; @(posedge clk);
            instruction_in = 16'h3333; @(posedge clk);
            instruction_in = 16'h4444; @(posedge clk);
            instruction_in = 16'h5555; @(posedge clk);

            instruction_in = 16'h0000;

            repeat (4) @(posedge clk);

            #1;


            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data Hazard Handling", test_num);
            reset_dut();


            instruction_in = 16'hB001; @(posedge clk);

            instruction_in = 16'hB001; @(posedge clk);

            instruction_in = 16'h0000;


            repeat (6) @(posedge clk);

            #1;


            check_outputs(16'hB001, 16'hB001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Pipeline Flush on Reset", test_num);
            reset_dut();


            instruction_in = 16'hDEAD; @(posedge clk);
            instruction_in = 16'hBEEF; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_data_out;
        input [15:0] expected_instruction_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, instruction_out=%h",
                         data_out, instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, instruction_out=%h",
                         expected_data_out, expected_instruction_out);
                $display("  Got:      data_out=%h, instruction_out=%h",
                         data_out, instruction_out);
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
        $dumpvars(0,clk, instruction_in, reset, data_out, instruction_out);
    end

endmodule
